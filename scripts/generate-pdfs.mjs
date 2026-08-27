#!/usr/bin/env node
// Renders each witness's diplomatic transcription pages (#textcontent-pb) to a
// pixel-accurate, vector-text PDF via headless Chromium, discovering the page
// sequence by clicking the site's own "next page" link (#nextPageLink) rather
// than parsing source XML or depending on a local build — fully decoupled,
// runs against the live deployed site by default.
//
// Usage:  node scripts/generate-pdfs.mjs
// Env:    PDF_BASE_URL      base URL of the site (default: production)
//         PDF_GEN_WITNESS   restrict to a single witness by name (debugging)

import { chromium } from "@playwright/test";
import { PDFDocument } from "pdf-lib";
import { mkdir, readFile, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import {
	CM_TO_PX,
	RUN_DATE,
	buildCoverCitationHtml,
	generateCoverPage as generateCitationCoverPage,
	loadCoverInfo,
	mergePdfs,
} from "./pdf-shared.mjs";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const OUT_DIR = path.join(ROOT, "pdf-output");
const OVERRIDES_PATH = path.join(__dirname, "pdf-page-overrides.json");
const COVER_INFO_PATH = path.join(__dirname, "pdf-cover-info.json");

const BASE_URL = (process.env.PDF_BASE_URL ?? "https://karl-kraus.github.io/wpn-static-dev").replace(/\/$/, "");

// Sanity cap for automatic page growth, per edge. Real margin-note overflow
// observed so far is a few cm; anything far beyond this is treated as a
// measurement artifact (see MAX_GROWTH_CM usage below) rather than content
// that should silently balloon the page size.
const MAX_GROWTH_CM = 10;

// Hard stop against an unexpected link cycle in #nextPageLink.
const MAX_PAGES_PER_WITNESS = 500;

// Extra space reserved at the bottom of every page for the source-URL footer.
const FOOTER_HEIGHT_CM = 1;

// A4 at 96 CSS px/inch (210mm/297mm), matching the size generateCoverPage()
// gets from page.pdf({ format: "A4" }) — the legend page is scaled to match.
const A4_WIDTH_PX = (210 / 25.4) * 96;
const A4_HEIGHT_PX = (297 / 25.4) * 96;
const LEGEND_PAGE_MARGIN_PX = (1.5 / 2.54) * 96; // 1.5cm, matching the cover page's logo padding

const WITNESSES = [
	{ name: "DfeH", startUrl: `${BASE_URL}/wit-DfeH-0001.html` },
	{ name: "TFragment2", startUrl: `${BASE_URL}/wit-TFragment2-0229r.html` },
	{ name: "HMotto", startUrl: `${BASE_URL}/wit-HMotto-0001r.html` },
	{ name: "DfMotto", startUrl: `${BASE_URL}/wit-DfMotto-0001r.html` },
	{ name: "TParalipomenon", startUrl: `${BASE_URL}/wit-TParalipomenon-0034r.html` },
	{ name: "DffH", startUrl: `${BASE_URL}/wit-DffH-0266_ar.html` },
];

// Physical page dimensions per pb/@type, from .print-page.<type> in scss/style.scss.
const PAGE_DIMENSIONS_CM = {
	witnessPrint: { width: 14.2, height: 21 },
	witnessPrint2: { width: 14.2, height: 21 },
	witnessNote1: { width: 10.3, height: 18.1 },
	witnessTypescript: { width: 19.4, height: 26 },
	witnessTypescript2: { width: 20.7, height: 26 },
	witnessTypescript3: { width: 20.7, height: 26 },
	witnessTypescript4: { width: 22.3, height: 28.8 },
	witnessTypescriptInsert: { width: 19.4, height: 26 },
};

// wpn-first-visit-overlay.ts keys, kept in sync in case that (currently
// commented-out in editions_typo.xsl) modal gets re-enabled later.
const FIRST_VISIT_OVERLAY_PATTERNS = [
	"^wit-DfeH.*\\.html$",
	"^wit-TFragment2.*\\.html$",
	"^wit-TParalipomenon.*\\.html$",
];

// Isolates #textcontent-pb: hides everything else, strips the responsive
// scale() transform and screen-only page chrome, and breaks #sub_grid_pb out
// of its 3-column grid (40/40/20%) so the text column starts flush at (0,0)
// regardless of the now-hidden facsimile/info columns' track widths.
const BASE_OVERRIDE_CSS = `
#primary_nav, nav[aria-label="breadcrumb"], footer.footer, #facscolumn, #infocolumn,
.modal, .modal-backdrop, .facsimile-source, #first-visit-info-overlay {
  display: none !important;
}
html, body, main, .container-fluid, #sub_grid_pb, #textcolumn-pb, #textcontent-pb {
  margin: 0 !important;
  padding: 0 !important;
}
#sub_grid_pb {
  display: block !important;
  height: auto !important;
  min-height: 0 !important;
}
#textcolumn-pb, #textcontent-pb {
  width: auto !important;
  height: auto !important;
  max-height: none !important;
  overflow: visible !important;
}
#textcontent-pb .print-page {
  transform: none !important;
  border: none !important;
  box-shadow: none !important;
}
`;

async function main() {
	await mkdir(OUT_DIR, { recursive: true });
	const overrides = await loadOverrides();
	const coverInfo = await loadCoverInfo(COVER_INFO_PATH);
	const only = process.env.PDF_GEN_WITNESS;
	const selected = only ? WITNESSES.filter((w) => w.name === only) : WITNESSES;
	if (only && selected.length === 0) {
		throw new Error(`PDF_GEN_WITNESS="${only}" does not match any known witness`);
	}

	console.log(`Base URL: ${BASE_URL}`);
	const browser = await chromium.launch();
	const overflowLog = [];
	const failures = [];
	try {
		// The legend's content is identical for every witness (sourced from
		// data/meta/topographical.xml, not per-witness data), so it only needs
		// to be captured once and is then reused for every witness PDF. Try
		// each witness's start page in turn in case the first isn't reachable.
		let legendBytes = null;
		for (const witness of selected) {
			try {
				legendBytes = await generateLegendPage(browser, witness.startUrl);
				break;
			} catch (err) {
				console.warn(`[warn] legend page via ${witness.name} failed: ${err.message}`);
			}
		}
		if (!legendBytes) {
			console.warn("[warn] could not generate the legend page from any witness — omitting it from all PDFs");
		}

		// allSettled, not all: one witness's start page being unreachable (e.g.
		// not yet deployed) must not discard already-completed work for the
		// others — each witness is written out independently as it finishes.
		const settled = await Promise.allSettled(
			selected.map((witness) => collectWitness(browser, witness, overrides, overflowLog)),
		);

		for (const [i, result] of settled.entries()) {
			const witness = selected[i];
			if (result.status === "rejected") {
				failures.push({ witness: witness.name, error: result.reason });
				console.error(`[failed] ${witness.name}: ${result.reason?.message ?? result.reason}`);
				continue;
			}
			const { name, pdfBytesList } = result.value;
			if (pdfBytesList.length === 0) {
				failures.push({ witness: name, error: new Error("start page unreachable — 0 pages collected") });
				console.error(`[failed] ${name}: start page unreachable, 0 pages collected`);
				continue;
			}
			let allPdfBytes = pdfBytesList;
			let coverAdded = false;
			const info = coverInfo[name];
			if (info) {
				try {
					const coverBytes = await generateCoverPage(browser, info);
					allPdfBytes = [coverBytes, ...allPdfBytes];
					coverAdded = true;
				} catch (err) {
					console.warn(`[warn] ${name}: cover page generation failed: ${err.message}`);
				}
			} else {
				console.warn(`[warn] ${name}: no entry in pdf-cover-info.json, skipping cover page`);
			}
			if (legendBytes) {
				// Right after the cover page, i.e. index 1 if a cover page was
				// added, index 0 (very first page) if it wasn't.
				const insertAt = coverAdded ? 1 : 0;
				allPdfBytes = [...allPdfBytes.slice(0, insertAt), legendBytes, ...allPdfBytes.slice(insertAt)];
			}
			const merged = await mergePdfs(allPdfBytes);
			const outPath = path.join(OUT_DIR, `${name}${process.env.PDF_GEN_OUT_SUFFIX ?? ""}.pdf`);
			await writeFile(outPath, merged);
			console.log(`[done] ${name}: ${pdfBytesList.length} pages -> ${outPath}`);
		}

		logOverflowSummary(overflowLog);

		if (failures.length > 0) {
			console.error(`\n[!] ${failures.length}/${selected.length} witness(es) failed:`);
			for (const f of failures) console.error(`    ${f.witness}: ${f.error?.message ?? f.error}`);
			process.exitCode = 1;
		}
	} finally {
		void browser.close();
	}
}

async function loadOverrides() {
	try {
		const raw = await readFile(OVERRIDES_PATH, "utf-8");
		return JSON.parse(raw);
	} catch (err) {
		if (err.code === "ENOENT") return { defaults: { overflowStrategy: "grow" }, witnesses: {}, pages: {} };
		throw err;
	}
}

function resolveStrategy(overrides, witnessName, pageId) {
	const pageCfg = overrides.pages?.[pageId] ?? {};
	const witnessCfg = overrides.witnesses?.[witnessName] ?? {};
	const defaults = overrides.defaults ?? {};
	return {
		strategy: pageCfg.overflowStrategy ?? witnessCfg.overflowStrategy ?? defaults.overflowStrategy ?? "grow",
		maxShrinkPercent: pageCfg.maxShrinkPercent ?? witnessCfg.maxShrinkPercent ?? defaults.maxShrinkPercent ?? 15,
		heightOverrideCm: pageCfg.heightOverrideCm,
		widthOverrideCm: pageCfg.widthOverrideCm,
		extraWidthWhenGrownCm: pageCfg.extraWidthWhenGrownCm ?? witnessCfg.extraWidthWhenGrownCm ?? defaults.extraWidthWhenGrownCm ?? 0,
	};
}

function pageIdFromUrl(url) {
	return path.basename(new URL(url).pathname, ".html");
}

async function collectWitness(browser, witness, overrides, overflowLog) {
	const pdfBytesList = [];
	let currentUrl = witness.startUrl;
	let iterations = 0;
	while (currentUrl) {
		if (++iterations > MAX_PAGES_PER_WITNESS) {
			throw new Error(`${witness.name}: exceeded ${MAX_PAGES_PER_WITNESS} pages — possible link cycle, aborting`);
		}
		let result;
		try {
			result = await capturePage(browser, witness.name, currentUrl, overrides);
		} catch (err) {
			// Stop the chain here rather than losing every page already
			// collected for this witness (e.g. hundreds of pages) over one
			// unreachable page — most likely cause: a page linked from the
			// site's own navigation that isn't deployed yet.
			console.error(`[stopped] ${witness.name} at ${currentUrl}: ${err.message}`);
			break;
		}
		const { pdfBytes, overflow, nextUrl } = result;
		if (pdfBytes) pdfBytesList.push(pdfBytes); // null for skipped "nonWitness" pages
		if (overflow) overflowLog.push({ witness: witness.name, id: pageIdFromUrl(currentUrl), ...overflow });
		currentUrl = nextUrl;
	}
	console.log(`[collected] ${witness.name}: ${pdfBytesList.length} pages`);
	return { name: witness.name, pdfBytesList };
}

// Retries the whole capture (navigation + rendering) up to 3 times — the live
// site is reached over real HTTP, unlike the previous local-server approach.
async function capturePage(browser, witnessName, url, overrides) {
	let lastErr;
	for (let attempt = 1; attempt <= 3; attempt++) {
		const context = await browser.newContext({ viewport: { width: 1880, height: 1000 } });
		try {
			return await capturePageOnce(context, witnessName, url, overrides);
		} catch (err) {
			lastErr = err;
			console.warn(`[retry ${attempt}/3] ${url}: ${err.message}`);
		} finally {
			await context.close();
		}
	}
	throw lastErr;
}

async function capturePageOnce(context, witnessName, url, overrides) {
	await context.addInitScript((patterns) => {
		for (const p of patterns) {
			window.localStorage.setItem(`wpn-first-visit-overlay-seen:${p}`, "1");
		}
	}, FIRST_VISIT_OVERLAY_PATTERNS);

	const page = await context.newPage();
	await page.goto(url, { waitUntil: "domcontentloaded", timeout: 60_000 });

	const printType = await page.evaluate((knownTypes) => {
		const printPage = document.querySelector(".print-page");
		if (!printPage) return null;
		if (printPage.classList.contains("nonWitness")) return "nonWitness";
		return knownTypes.find((t) => printPage.classList.contains(t)) ?? null;
	}, Object.keys(PAGE_DIMENSIONS_CM));
	if (!printType) {
		throw new Error(`${url}: could not determine printType from .print-page class list`);
	}

	// "nonWitness" pages (e.g. an inserted leaf cross-referenced from a
	// witness's own sequence) are explicitly excluded from normal witness
	// page navigation/counting elsewhere in the app
	// (tei:pb[not(@type='nonWitness')] in xslt/partials/typo-info-3rd-column.xsl)
	// — skip capturing a PDF page for them, but still follow their own
	// #nextPageLink (if any) to keep the chain going.
	if (printType === "nonWitness") {
		const nextUrl = await page.$eval("#nextPageLink", (el) => el.href).catch(() => null);
		return { pdfBytes: null, overflow: null, nextUrl };
	}

	await page.evaluate(() => document.fonts.ready);

	// Re-run wpn-hf-height.ts's header/footer centering now that fonts are
	// guaranteed loaded (the original script runs once, synchronously,
	// during initial parsing, before web fonts are necessarily ready).
	await page.evaluate(() => {
		const printPage = document.querySelector(".print-page");
		const body = document.querySelector(".body-main")?.childNodes;
		const header = document.querySelector(".print-header");
		const footer = document.querySelector(".print-footer");
		if (!printPage || !body || !header || !footer) return;
		let textHeight = 0;
		for (const child of body) {
			if (child.nodeName === "#text") continue;
			textHeight += child.offsetHeight ?? 0;
		}
		let headerHeight = (printPage.offsetHeight - textHeight) * 0.5;
		let footerHeight = (printPage.offsetHeight - textHeight) * 0.5;
		if (document.querySelector(".witnessTypescriptInsert")) {
			headerHeight = printPage.offsetHeight * 0.081;
			footerHeight = printPage.offsetHeight - textHeight - headerHeight;
		}
		header.style.height = `${headerHeight}px`;
		footer.style.height = `${footerHeight}px`;
	});

	await page.addStyleTag({ content: BASE_OVERRIDE_CSS });

	// Measure the true content extent on all four edges of .print-page —
	// covers .body-main, the independently-flowing body-left/body-right
	// margin-note columns, and position-absolute tei:note[@place] notes
	// (some of which have negative top/left offsets by design).
	const overflowPx = await page.evaluate(() => {
		const printPage = document.querySelector(".print-page");
		const p = printPage.getBoundingClientRect();
		const box = { top: p.top, left: p.left, right: p.right, bottom: p.bottom };
		for (const el of printPage.querySelectorAll("*")) {
			const r = el.getBoundingClientRect();
			if (r.width === 0 && r.height === 0) continue;
			box.top = Math.min(box.top, r.top);
			box.left = Math.min(box.left, r.left);
			box.right = Math.max(box.right, r.right);
			box.bottom = Math.max(box.bottom, r.bottom);
		}
		return {
			top: p.top - box.top,
			left: p.left - box.left,
			right: box.right - p.right,
			bottom: box.bottom - p.bottom,
		};
	});

	const nominal = PAGE_DIMENSIONS_CM[printType];
	const pageId = pageIdFromUrl(url);
	const cfg = resolveStrategy(overrides, witnessName, pageId);

	let widthCm = cfg.widthOverrideCm ?? nominal.width;
	let heightCm = cfg.heightOverrideCm ?? nominal.height;
	let overflowReport = null;

	const hasOverflow =
		overflowPx.top > 1 || overflowPx.left > 1 || overflowPx.right > 1 || overflowPx.bottom > 1;

	if (hasOverflow && !cfg.heightOverrideCm && !cfg.widthOverrideCm) {
		const topCm = Math.max(0, overflowPx.top) / CM_TO_PX;
		const leftCm = Math.max(0, overflowPx.left) / CM_TO_PX;
		const rightCm = Math.max(0, overflowPx.right) / CM_TO_PX;
		const bottomCm = Math.max(0, overflowPx.bottom) / CM_TO_PX;

		// Some pages contain a `white-space: nowrap` run with no line break
		// (#textcolumn-pb forces nowrap sitewide so diplomatic line breaks
		// stay exact; on screen this is invisible because overflow-y:scroll
		// implicitly forces overflow-x:auto there) that can measure in the
		// hundreds of cm — not real margin-note overflow. Growth is capped
		// and the real, uncapped amount is logged for follow-up.
		const wasCapped =
			topCm > MAX_GROWTH_CM || leftCm > MAX_GROWTH_CM || rightCm > MAX_GROWTH_CM || bottomCm > MAX_GROWTH_CM;
		const cappedTopCm = Math.min(topCm, MAX_GROWTH_CM);
		const cappedLeftCm = Math.min(leftCm, MAX_GROWTH_CM);
		const cappedRightCm = Math.min(rightCm, MAX_GROWTH_CM);
		const cappedBottomCm = Math.min(bottomCm, MAX_GROWTH_CM);

		if (cfg.strategy === "shrink" && !wasCapped) {
			const requiredScale = Math.min(
				nominal.width / (nominal.width + leftCm + rightCm),
				nominal.height / (nominal.height + topCm + bottomCm),
			);
			const minAllowedScale = 1 - cfg.maxShrinkPercent / 100;
			if (requiredScale < minAllowedScale) {
				// Even at the max allowed shrink it wouldn't fit — grow instead
				// of silently cropping content.
				await page.addStyleTag({
					content: `#textcontent-pb { padding-top: ${topCm}cm !important; padding-left: ${leftCm}cm !important; }`,
				});
				widthCm = nominal.width + leftCm + rightCm;
				heightCm = nominal.height + topCm + bottomCm;
				overflowReport = { strategy: "grow (shrink insufficient)", top: topCm, bottom: bottomCm, left: leftCm, right: rightCm };
			} else {
				await page.addStyleTag({
					content: `#textcontent-pb .print-page { transform: scale(${requiredScale}) !important; transform-origin: top left !important; }`,
				});
				overflowReport = { strategy: "shrink", scale: requiredScale, top: topCm, bottom: bottomCm, left: leftCm, right: rightCm };
			}
		} else {
			// Clip (not just fail to allocate space for) anything beyond the
			// capped box, so Chromium never has to paginate overflow content
			// onto a second PDF page.
			await page.addStyleTag({
				content: `#textcontent-pb {
					padding-top: ${cappedTopCm}cm !important;
					padding-left: ${cappedLeftCm}cm !important;
					overflow: ${wasCapped ? "hidden" : "visible"} !important;
				}`,
			});
			widthCm = nominal.width + cappedLeftCm + cappedRightCm;
			heightCm = nominal.height + cappedTopCm + cappedBottomCm;
			overflowReport = {
				strategy: wasCapped ? "grow (CAPPED — check source markup / consider a config override)" : "grow",
				top: topCm,
				bottom: bottomCm,
				left: leftCm,
				right: rightCm,
				capped: wasCapped,
			};
		}
	}

	// Some witnesses' margin notes still clip slightly against the edge of an
	// otherwise-correctly-grown page even after the overflow-based sizing
	// above — a fixed safety margin added on top, only where the page has
	// actually already grown past its nominal sheet width (i.e. this doesn't
	// widen every page, just the ones with overflowing notes in the first
	// place). Configured per-witness (see extraWidthWhenGrownCm in
	// pdf-page-overrides.json), not hardcoded to any one witness here.
	if (widthCm > nominal.width && cfg.extraWidthWhenGrownCm > 0) {
		widthCm += cfg.extraWidthWhenGrownCm;
	}

	// Footer: clickable source URL (view-state query params stripped — they're
	// UI toggles, not part of a citable address) + the date this run captured
	// it. Appended as a normal-flow sibling after .print-page so it neither
	// disturbs that element's own (already-finalized) box nor gets clipped by
	// the overflow:hidden set above in the capped case (only .print-page's
	// overflowing descendants are clipped there, not #textcontent-pb's own
	// normal-flow content).
	const cleanUrl = url.split("?")[0];
	await page.evaluate(
		({ cleanUrl, dateStr, footerHeightPx }) => {
			const printPage = document.querySelector(".print-page");
			const container = document.querySelector("#textcontent-pb");
			const footer = document.createElement("div");
			footer.style.cssText = `
				box-sizing: border-box;
				width: ${printPage.offsetWidth}px;
				height: ${footerHeightPx}px;
				display: flex;
				align-items: center;
				justify-content: center;
				font-family: Arial, Helvetica, sans-serif;
				font-size: 8px;
				color: #555555;
			`;
			const link = document.createElement("a");
			link.href = cleanUrl;
			link.textContent = cleanUrl;
			link.style.color = "#555555";
			footer.appendChild(link);
			// A leading plain space in a text node that is an anonymous flex
			// item (this footer is display:flex) gets trimmed away by
			// Chromium, so a non-breaking space (\u00A0) is used instead.
			footer.appendChild(document.createTextNode(`\u00A0[${dateStr}]`));
			container.appendChild(footer);
		},
		{ cleanUrl, dateStr: RUN_DATE, footerHeightPx: FOOTER_HEIGHT_CM * CM_TO_PX },
	);
	heightCm += FOOTER_HEIGHT_CM;

	await page.emulateMedia({ media: "screen" });
	const pdfBuffer = await page.pdf({
		width: `${widthCm}cm`,
		height: `${heightCm}cm`,
		printBackground: true,
		margin: { top: 0, right: 0, bottom: 0, left: 0 },
	});

	const doc = await PDFDocument.load(pdfBuffer);
	if (doc.getPageCount() !== 1) {
		throw new Error(
			`Expected 1 PDF page for ${url}, got ${doc.getPageCount()} — overflow handling produced a wrong size`,
		);
	}

	// Determine the next page via #nextPageLink's resolved href — not a real
	// .click(), because BASE_OVERRIDE_CSS hides #infocolumn (which contains
	// #nextPageLink) for the capture, making it non-actionable for Playwright.
	// Reading the already browser-resolved absolute href is equivalent to
	// following the link and doesn't depend on visibility. The last page of a
	// witness renders only a disabled <span> in its place
	// (xslt/partials/typo-info-3rd-column.xsl) — #nextPageLink is then absent.
	const nextUrl = await page.$eval("#nextPageLink", (el) => el.href).catch(() => null);

	return { pdfBytes: pdfBuffer, overflow: overflowReport, nextUrl };
}

// One plain, non-facsimile-styled A4 title page per witness PDF, prepended
// before merging. Content comes from scripts/pdf-cover-info.json (per-witness
// `{ text, url, facsurl? }`), not scraped from the page, so each witness's
// cover text can be edited independently of the site. `info.url` is only the
// tail of the page's URL — joined onto BASE_URL here.
async function generateCoverPage(browser, info) {
	return generateCitationCoverPage(browser, buildCoverCitationHtml(info, BASE_URL));
}

// Captures the actual "Legende" panel from the info column (#legende-pb,
// normally revealed by clicking #legende-btn; content sourced site-wide from
// data/meta/topographical.xml, identical for every witness/page) exactly as
// rendered — not reconstructed as plain HTML — because its list items rely
// on the same hand/ink-colour CSS classes used throughout the transcription,
// which is precisely the formatting that must be preserved. Reused as-is
// across every witness PDF since the content doesn't vary by witness.
async function generateLegendPage(browser, url) {
	const context = await browser.newContext({ viewport: { width: 1880, height: 1000 } });
	try {
		const page = await context.newPage();
		await page.goto(url, { waitUntil: "domcontentloaded", timeout: 60_000 });
		await page.evaluate(() => document.fonts.ready);

		// Natural rendered width of the info column, measured before any
		// override touches layout — this is "the formatting there": the
		// legend's line-wrapping as it actually appears on the site.
		const legendWidthPx = await page.evaluate(() => document.querySelector("#infocolumn").offsetWidth);

		// Reveal #legende-pb exactly the way #legende-btn's click handler does
		// (wpn-utils/wpn-typo-utils.ts): toggle off the Bootstrap
		// .visually-hidden class, nothing more.
		await page.evaluate(() => {
			document.querySelector("#legende-pb")?.classList.remove("visually-hidden");
		});

		await page.addStyleTag({
			content: `
				#primary_nav, nav[aria-label="breadcrumb"], footer.footer, #facscolumn, #textcolumn-pb,
				#infocontent-header, #legend-header, #pagination-pb, #infocontent-pb, .modal, .modal-backdrop, #first-visit-info-overlay {
					display: none !important;
				}
				html, body, main, .container-fluid, #sub_grid_pb, #infocolumn, #infocontent, #infocontent-wrapper {
					margin: 0 !important;
					padding: 0 !important;
				}
				html, body, main {
					height: auto !important;
					min-height: 0 !important;
				}
				#sub_grid_pb {
					display: block !important;
					height: auto !important;
					min-height: 0 !important;
				}
				#infocolumn, #infocontent, #infocontent-wrapper, #legende-pb {
					height: auto !important;
					min-height: 0 !important;
					max-height: none !important;
					overflow: visible !important;
				}
				#infocolumn {
					width: ${legendWidthPx}px !important;
				}
			`,
		});

		// Not #legende-pb's own getBoundingClientRect(): its Bootstrap
		// min-h-100/min-vh-100 classes are neutralized above, but its content
		// can still extend past its own box in ways that don't grow that box
		// (same reasoning as the per-page overflow measurement above) — so the
		// true extent is measured across every descendant instead.
		const legendHeightPx = await page.evaluate(() => {
			const el = document.querySelector("#legende-pb");
			const top = el.getBoundingClientRect().top;
			let maxBottom = el.getBoundingClientRect().bottom;
			for (const child of el.querySelectorAll("*")) {
				const r = child.getBoundingClientRect();
				if (r.width === 0 && r.height === 0) continue;
				maxBottom = Math.max(maxBottom, r.bottom);
			}
			return maxBottom - top;
		});

		// Fit (scale up or down, preserving proportions — and with them the
		// preserved formatting) into an A4 page the same size as the cover
		// page, centred within a margin matching the cover page's logo
		// padding. Scaling only changes the overall size, not the relative
		// text-wrapping/layout established above, so this doesn't reintroduce
		// the "formatting must be preserved" problem solved by measuring the
		// natural width in the first place.
		const availableWidthPx = A4_WIDTH_PX - 2 * LEGEND_PAGE_MARGIN_PX;
		const availableHeightPx = A4_HEIGHT_PX - 2 * LEGEND_PAGE_MARGIN_PX;
		const scale = Math.min(availableWidthPx / legendWidthPx, availableHeightPx / legendHeightPx);
		const scaledWidthPx = legendWidthPx * scale;
		const scaledHeightPx = legendHeightPx * scale;
		const offsetLeftPx = (A4_WIDTH_PX - scaledWidthPx) / 2;
		const offsetTopPx = (A4_HEIGHT_PX - scaledHeightPx) / 2;

		await page.addStyleTag({
			content: `
				html, body {
					width: ${A4_WIDTH_PX}px !important;
					height: ${A4_HEIGHT_PX}px !important;
					position: relative !important;
					overflow: hidden !important;
				}
				main, .container-fluid, #sub_grid_pb {
					position: static !important;
				}
				#infocolumn {
					position: absolute !important;
					top: ${offsetTopPx}px !important;
					left: ${offsetLeftPx}px !important;
					transform: scale(${scale}) !important;
					transform-origin: top left !important;
				}
			`,
		});

		await page.emulateMedia({ media: "screen" });
		const pdfBuffer = await page.pdf({
			format: "A4",
			printBackground: true,
			margin: { top: 0, right: 0, bottom: 0, left: 0 },
		});

		const doc = await PDFDocument.load(pdfBuffer);
		if (doc.getPageCount() !== 1) {
			throw new Error(`legend page unexpectedly spans ${doc.getPageCount()} pages`);
		}
		return pdfBuffer;
	} finally {
		await context.close();
	}
}

function logOverflowSummary(overflowLog) {
	const cappedEntries = overflowLog.filter((e) => e.capped);
	if (overflowLog.length > 0) {
		console.log(`\n${overflowLog.length} page(s) exceeded their nominal physical size:`);
		for (const entry of overflowLog) {
			console.log(
				`  ${entry.witness}/${entry.id}: ${entry.strategy}` +
					(entry.scale ? ` (scale ${entry.scale.toFixed(3)})` : "") +
					` top=${entry.top?.toFixed(2) ?? 0}cm bottom=${entry.bottom?.toFixed(2) ?? 0}cm` +
					` left=${entry.left?.toFixed(2) ?? 0}cm right=${entry.right?.toFixed(2) ?? 0}cm`,
			);
		}
	} else {
		console.log("\nNo pages exceeded their nominal physical size.");
	}
	if (cappedEntries.length > 0) {
		console.warn(
			`\n[!] ${cappedEntries.length} page(s) had overflow beyond the ${MAX_GROWTH_CM}cm sanity cap and were CLIPPED ` +
				`instead of grown — likely a missing <lb/> under a white-space:nowrap run rather than real content. ` +
				`Review these and add a scripts/pdf-page-overrides.json entry (or fix the source markup) if needed:`,
		);
		for (const entry of cappedEntries) console.warn(`    ${entry.witness}/${entry.id}`);
	}
}

main().catch((err) => {
	console.error(err);
	process.exitCode = 1;
});
