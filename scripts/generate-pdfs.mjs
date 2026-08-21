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

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const OUT_DIR = path.join(ROOT, "pdf-output");
const OVERRIDES_PATH = path.join(__dirname, "pdf-page-overrides.json");

const BASE_URL = (process.env.PDF_BASE_URL ?? "https://karl-kraus.github.io/wpn-static-dev").replace(/\/$/, "");
const CM_TO_PX = 96 / 2.54;

// Sanity cap for automatic page growth, per edge. Real margin-note overflow
// observed so far is a few cm; anything far beyond this is treated as a
// measurement artifact (see MAX_GROWTH_CM usage below) rather than content
// that should silently balloon the page size.
const MAX_GROWTH_CM = 10;

// Hard stop against an unexpected link cycle in #nextPageLink.
const MAX_PAGES_PER_WITNESS = 500;

// Extra space reserved at the bottom of every page for the source-URL footer.
const FOOTER_HEIGHT_CM = 1;

// Fixed for the whole run, not per-page, so every footer/cover page in one
// PDF shows the same "accessed on" date even if capture takes several minutes.
const RUN_DATE = (() => {
	const d = new Date();
	return `${String(d.getDate()).padStart(2, "0")}.${String(d.getMonth() + 1).padStart(2, "0")}.${d.getFullYear()}`;
})();

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
			const { name, pdfBytesList, title } = result.value;
			if (pdfBytesList.length === 0) {
				failures.push({ witness: name, error: new Error("start page unreachable — 0 pages collected") });
				console.error(`[failed] ${name}: start page unreachable, 0 pages collected`);
				continue;
			}
			let allPdfBytes = pdfBytesList;
			let coverAdded = false;
			if (title) {
				try {
					const coverBytes = await generateCoverPage(browser, title, BASE_URL);
					allPdfBytes = [coverBytes, ...allPdfBytes];
					coverAdded = true;
				} catch (err) {
					console.warn(`[warn] ${name}: cover page generation failed: ${err.message}`);
				}
			} else {
				console.warn(`[warn] ${name}: could not extract title, skipping cover page`);
			}
			if (legendBytes) {
				// Right after the cover page, i.e. index 1 if a cover page was
				// added, index 0 (very first page) if it wasn't.
				const insertAt = coverAdded ? 1 : 0;
				allPdfBytes = [...allPdfBytes.slice(0, insertAt), legendBytes, ...allPdfBytes.slice(insertAt)];
			}
			const merged = await mergeWitnessPdf(allPdfBytes);
			const outPath = path.join(OUT_DIR, `${name}.pdf`);
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
	};
}

function pageIdFromUrl(url) {
	return path.basename(new URL(url).pathname, ".html");
}

async function collectWitness(browser, witness, overrides, overflowLog) {
	const pdfBytesList = [];
	let title = null;
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
		const { pdfBytes, overflow, nextUrl, title: pageTitle } = result;
		if (pdfBytes) pdfBytesList.push(pdfBytes); // null for skipped "nonWitness" pages
		if (!title && pageTitle) title = pageTitle;
		if (overflow) overflowLog.push({ witness: witness.name, id: pageIdFromUrl(currentUrl), ...overflow });
		currentUrl = nextUrl;
	}
	console.log(`[collected] ${witness.name}: ${pdfBytesList.length} pages`);
	return { name: witness.name, pdfBytesList, title };
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

	// Witness title for the cover page: the info column's h4 ("<Title>, fol.
	// [N]"), with the page-specific ", fol. [N]" suffix stripped — identical
	// across a witness's pages bar that suffix, so any one page's copy will do.
	// innerHTML (not textContent) to keep the title's <sup> formatting (e.g.
	// "T<sup>Fragment 2</sup>") for the cover page.
	const rawTitle = await page
		.$eval("#infocontent-pb h4", (el) => el.innerHTML.trim())
		.catch(() => null);
	const title = rawTitle ? rawTitle.replace(/,\s*fol\.\s*\[[^\]]*\]\s*$/, "").trim() : null;

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

	return { pdfBytes: pdfBuffer, overflow: overflowReport, nextUrl, title };
}

function escapeHtml(str) {
	return str.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

// Copied as-is from the <g id="LOGO-Karl-Kraus-1933_FARBE"> paths in
// xslt/partials/html_navbar.xsl (the site's own navbar logo), just with the
// XSLT attribute-value-template width expression replaced by a fixed value.
const LOGO_SVG = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 123.47 106.97" width="100" aria-hidden="true" focusable="false">
  <defs><style>.cls-1{fill:#4a4a49;}.cls-2{fill:#a21a17;}</style></defs>
  <g id="Ebene_2" data-name="Ebene 2">
    <g id="KARLKRAUS1933-EXPORT">
      <g id="LOGO-Karl-Kraus-1933_FARBE">
        <path class="cls-1" d="M21.24,49v9.32h2.18L29.17,49h6.6L28.42,60.93l8,12.71H29.49l-6.11-9.89H21.24v9.89H15.46V49Z"/>
        <path class="cls-1" d="M49.09,49a10.73,10.73,0,0,1,5.79,1.32c1.6,1,2.71,2.68,2.71,5.71,0,3.4-1.36,6-4.64,6.82,3.1.58,4,3.61,4.78,10.79H51.66c-.89-6.64-1.39-8.36-3.61-8.36H44.81v8.36H39V49ZM44.81,60.43h2.6c2.75,0,4.18-.61,4.18-3.72a2.88,2.88,0,0,0-.68-2.28,3,3,0,0,0-2.14-.5h-4Z"/>
        <path class="cls-1" d="M76.19,73.64,74.87,69H67.05l-1.32,4.68H59.84L67.59,49h6.93l7.74,24.64ZM71,54.82,68.3,64.35h5.36Z"/>
        <path class="cls-1" d="M89.69,49V64.85c0,2.65.22,4.22,3.89,4.22,3.5,0,3.82-1.43,3.82-4.22V49h5.79V64.78c0,2.32-.32,4.5-1.64,6.18s-4.07,3.11-8.18,3.11S87,72.89,85.66,71.32c-1.47-1.75-1.75-4.07-1.75-6.36V49Z"/>
        <path class="cls-1" d="M120.22,54.89A9.87,9.87,0,0,0,115,53.46c-1.75,0-2.89.47-2.89,2.4,0,3.75,11.32,1.53,11.32,10.46a7,7,0,0,1-3.11,6A11.58,11.58,0,0,1,114,74.07c-2.61,0-6.14-.65-8.14-2.47l2.85-4.25a9.85,9.85,0,0,0,5.86,1.82c1.68,0,3.07-.42,3.07-2.57,0-4.25-11.32-1.82-11.32-10.6a6.4,6.4,0,0,1,2.79-5.5,10.53,10.53,0,0,1,6.42-1.93c2.36,0,5.54.57,7.43,2.14Z"/>
        <path class="cls-1" d="M21.24,18.79v9.32h2.18l5.75-9.32h6.6L28.42,30.72l8,12.71H29.49l-6.11-9.89H21.24v9.89H15.46V18.79Z"/>
        <path class="cls-1" d="M54.16,43.43l-1.32-4.68H45L43.7,43.43H37.8l7.75-24.64h6.93l7.75,24.64ZM49,24.61l-2.68,9.54h5.35Z"/>
        <path class="cls-1" d="M72.87,18.79a10.63,10.63,0,0,1,5.78,1.33c1.61,1,2.72,2.67,2.72,5.71,0,3.39-1.36,6-4.64,6.82,3.1.57,4,3.6,4.78,10.78H75.44c-.89-6.64-1.39-8.35-3.61-8.35H68.59v8.35H62.8V18.79ZM68.59,30.22h2.6c2.75,0,4.18-.61,4.18-3.71a2.94,2.94,0,0,0-.68-2.29,3.07,3.07,0,0,0-2.14-.5h-4Z"/>
        <path class="cls-1" d="M91,18.79v19.5h8.46v5.14H85.24V18.79Z"/>
        <path class="cls-2" d="M19.28,86.21v19.44H17.72v-18H15.37V86.21Z"/>
        <path class="cls-2" d="M24.52,92.21A6.24,6.24,0,0,1,31,85.89a6.2,6.2,0,0,1,6.39,6.45c0,4.48-4.67,10.69-8.17,13.31H26.9a27.53,27.53,0,0,0,7.56-8.5,5.2,5.2,0,0,1-3.59,1.35A6.2,6.2,0,0,1,24.52,92.21Zm1.57,0A4.86,4.86,0,1,0,31,87.29,4.73,4.73,0,0,0,26.09,92.21Z"/>
        <path class="cls-2" d="M44.53,87.32a9.53,9.53,0,0,0-4.24,1.11V86.86a10.53,10.53,0,0,1,4.32-1c3.48,0,5.78,2,5.78,5a5,5,0,0,1-3.76,4.67,5.21,5.21,0,0,1,4.08,5.13c0,3-2.46,5.23-6.1,5.23a9.34,9.34,0,0,1-4.7-1.1V103.3a8.72,8.72,0,0,0,4.65,1.24c2.72,0,4.53-1.67,4.53-3.86,0-2.75-2.11-4.37-5.64-4.37H43V95h.73c2.86,0,5.08-1.62,5.08-4S47,87.32,44.53,87.32Z"/>
        <path class="cls-2" d="M58.43,87.32a9.53,9.53,0,0,0-4.23,1.11V86.86a10.48,10.48,0,0,1,4.31-1c3.49,0,5.78,2,5.78,5a5,5,0,0,1-3.75,4.67,5.21,5.21,0,0,1,4.07,5.13c0,3-2.45,5.23-6.1,5.23a9.3,9.3,0,0,1-4.69-1.1V103.3a8.68,8.68,0,0,0,4.64,1.24c2.73,0,4.53-1.67,4.53-3.86,0-2.75-2.1-4.37-5.64-4.37h-.48V95h.73c2.86,0,5.07-1.62,5.07-4S60.94,87.32,58.43,87.32Z"/>
        <path class="cls-2" d="M4,18.79H0v-14A4.84,4.84,0,0,1,4.83,0H15.45V4H4.83A.83.83,0,0,0,4,4.83Z"/>
      </g>
    </g>
  </g>
</svg>`;

// One plain, non-facsimile-styled A4 title page per witness PDF, prepended
// before merging — the citation text a reader would need to reference this
// specific transcription (title without the page-specific ", fol. [N]").
// `title` is trusted HTML (extracted from the site's own rendered <h4>, kept
// to preserve its <sup> formatting), not escaped like the plain-text baseUrl.
async function generateCoverPage(browser, title, baseUrl) {
	const context = await browser.newContext();
	try {
		const page = await context.newPage();
		const citation =
			`${title}. Topographische Transkription. In: Karl Kraus: Dritte Walpurgisnacht. ` +
			`Digitale Edition. Hg. v. Bernhard Oberreither. <a href="${escapeHtml(baseUrl)}">${escapeHtml(baseUrl)}</a>`;
		await page.setContent(`<!doctype html>
<html><head><meta charset="utf-8"><style>
  body { font-family: Georgia, 'Times New Roman', serif; margin: 0; color: #111111; }
  .cover-logo { padding: 1.5cm 1.5cm 0 1.5cm; }
  .cover-citation { margin: 5cm 3cm 3cm 3cm; font-size: 13pt; line-height: 1.7; }
  a { color: #111111; }
</style></head>
<body>
  <div class="cover-logo">${LOGO_SVG}</div>
  <div class="cover-citation"><p>${citation}</p></div>
</body></html>`);
		const pdfBuffer = await page.pdf({ format: "A4", printBackground: true });
		const doc = await PDFDocument.load(pdfBuffer);
		if (doc.getPageCount() !== 1) {
			throw new Error(`cover page unexpectedly spans ${doc.getPageCount()} pages`);
		}
		return pdfBuffer;
	} finally {
		await context.close();
	}
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

		// A fractional pixel height (e.g. "903.9375px") passed to page.pdf()
		// can round down internally and spill a near-empty sliver of content
		// onto a second page — round up, plus a couple of px of headroom.
		const safeHeightPx = Math.ceil(legendHeightPx) + 2;

		await page.emulateMedia({ media: "screen" });
		const pdfBuffer = await page.pdf({
			width: `${legendWidthPx}px`,
			height: `${safeHeightPx}px`,
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

async function mergeWitnessPdf(pdfBytesList) {
	const merged = await PDFDocument.create();
	for (const bytes of pdfBytesList) {
		const src = await PDFDocument.load(bytes);
		const [copiedPage] = await merged.copyPages(src, [0]);
		merged.addPage(copiedPage);
	}
	return merged.save();
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
