#!/usr/bin/env node
// Renders the "Annotierte Lesefassung" (motto.html + absatz_1..64.html) into a
// single, vector-text PDF. Unlike scripts/generate-pdfs.mjs (one physical
// witness page == one source URL == one PDF page), this reading edition has
// no physical-page source: its ~65 source pages are collected, concatenated
// into one continuous flow, and re-paginated by actually measuring rendered
// line positions in the browser — so paragraphs (Absätze) are not forced onto
// their own page, they simply continue wherever the previous one ran out of
// room. A narrow right-hand column repeats the site's own (currently hidden)
// "Beginn Blatt [N] (<Absatz>)" pagebreak labels, aligned to the exact height
// of the pagebreak marker they belong to.
//
// Usage:  node scripts/generate-lesefassung-pdf.mjs
// Env:    PDF_BASE_URL              base URL of the site (default: production)
//         PDF_LESEFASSUNG_LIMIT     only collect the first N absätze (debugging)

import { chromium } from "@playwright/test";
import { PDFDocument } from "pdf-lib";
import { mkdir, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { CM_TO_PX, RUN_DATE, buildCoverCitationHtml, escapeHtml, generateCoverPage, loadCoverInfo, mergePdfs } from "./pdf-shared.mjs";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const OUT_DIR = path.join(ROOT, "pdf-output");
const OUT_PATH = path.join(OUT_DIR, process.env.PDF_LESEFASSUNG_OUT ?? "Lesefassung.pdf");
const COVER_INFO_PATH = path.join(__dirname, "pdf-cover-info.json");

const BASE_URL = (process.env.PDF_BASE_URL ?? "https://kraus1933.acdh.oeaw.ac.at").replace(/\/$/, "");

// motto.html, then absatz_1.html .. absatz_64.html, per the site's own
// wpn-pagination dropdown on motto.html.
const ABSATZ_COUNT = 64;
const SOURCE_FILES = ["motto.html", ...Array.from({ length: ABSATZ_COUNT }, (_, i) => `absatz_${i + 1}.html`)];
const LIMIT = process.env.PDF_LESEFASSUNG_LIMIT ? Number(process.env.PDF_LESEFASSUNG_LIMIT) : null;
const PAGES_TO_COLLECT = LIMIT ? SOURCE_FILES.slice(0, LIMIT) : SOURCE_FILES;

// Physical page: width/height are both derived from their parts below, not
// fixed — the reading area (TEXT_WIDTH_CM x CONTENT_AREA_HEIGHT_CM) and
// SIDEBAR_WIDTH_CM never shrink; the page instead grows to fit whatever
// margin/gap is added around them.
const TEXT_WIDTH_CM = 14.2;
const SIDEBAR_GUTTER_CM = 0.3;
const SIDEBAR_WIDTH_CM = 2.5;
const MARGIN_LEFT_CM = 1.0; // witnessPrint-style 0.5cm + 5mm
const MARGIN_TOP_CM = 1.5; // witnessPrint-style 0.5cm + 10mm
const MARGIN_RIGHT_CM = 0.5;
const FOOTER_HEIGHT_CM = 1;
const FOOTER_GAP_CM = 0.3;
const CONTENT_AREA_HEIGHT_CM = 19.5;
const PAGE_WIDTH_CM = MARGIN_LEFT_CM + TEXT_WIDTH_CM + SIDEBAR_GUTTER_CM + SIDEBAR_WIDTH_CM + MARGIN_RIGHT_CM;
const PAGE_HEIGHT_CM = MARGIN_TOP_CM + CONTENT_AREA_HEIGHT_CM + FOOTER_GAP_CM + FOOTER_HEIGHT_CM;
const CONTENT_AREA_HEIGHT_PX = CONTENT_AREA_HEIGHT_CM * CM_TO_PX;
const TEXT_WIDTH_PX = TEXT_WIDTH_CM * CM_TO_PX;

// Hard stop against a pagination bug (e.g. a measured line taller than a
// whole page) turning the packing loop below into an infinite loop.
const MAX_OUTPUT_PAGES = 3000;

async function main() {
	await mkdir(OUT_DIR, { recursive: true });
	console.log(`Base URL: ${BASE_URL}`);
	console.log(`Collecting ${PAGES_TO_COLLECT.length} source page(s)...`);

	const browser = await chromium.launch();
	try {
		const sourcePages = await collectSourcePages(browser);

		console.log(`Assembling continuous flow and measuring line positions...`);
		const context = await browser.newContext({ viewport: { width: 1400, height: 1000 } });
		try {
			const page = await context.newPage();
			const layout = await assembleAndMeasure(page, sourcePages);

			console.log(`Packing ${layout.totalHeightPx.toFixed(0)}px of content into ${PAGE_WIDTH_CM}x${PAGE_HEIGHT_CM}cm pages...`);
			const windows = packPages(layout);
			console.log(`-> ${windows.length} page(s)`);

			const pageBytesList = [];
			for (const [i, win] of windows.entries()) {
				pageBytesList.push(await renderPage(page, win, layout));
				if ((i + 1) % 20 === 0) console.log(`  rendered ${i + 1}/${windows.length}`);
			}

			const coverInfo = await loadCoverInfo(COVER_INFO_PATH);
			const info = coverInfo.Lesefassung;
			if (!info) console.warn(`[warn] no "Lesefassung" entry in ${COVER_INFO_PATH} — using a generic fallback cover text`);
			const citation = info
				? buildCoverCitationHtml(info, BASE_URL)
				: `Digitale Edition. Hg. v. Bernhard Oberreither. <a href="${escapeHtml(BASE_URL)}">${escapeHtml(BASE_URL)}</a>`;
			// No "3rd column" info-panel title exists for the reading edition
			// (unlike the witness pages in generate-pdfs.mjs), so this heading is
			// a fixed stand-in rather than scraped from the site.
			const coverBytes = await generateCoverPage(browser, citation, "Dritte Walpurgisnacht. Lesefassung");

			const merged = await mergePdfs([coverBytes, ...pageBytesList]);
			await writeFile(OUT_PATH, merged);
			console.log(`[done] Lesefassung: ${pageBytesList.length} pages -> ${OUT_PATH}`);
		} finally {
			await context.close();
		}
	} finally {
		await browser.close();
	}
}

// #textcontent occasionally isn't in the DOM yet right after
// domcontentloaded (e.g. a slow connection still fetching/hydrating it), not
// because the page genuinely lacks one — worth a few delayed re-checks before
// giving up. No Absatz may silently go missing from the reading edition, so
// exhausting these retries aborts the whole build rather than skipping it.
const MAX_TEXTCONTENT_ATTEMPTS = 5;
const TEXTCONTENT_RETRY_DELAY_MS = 2000;

// --- Phase 1: collect each source page's #textcontent fragment + its hidden
// pagebreak short-info entries, one browser context per page (mirrors
// generate-pdfs.mjs's per-page context lifecycle). ---
async function collectSourcePages(browser) {
	const sourcePages = [];
	for (const file of PAGES_TO_COLLECT) {
		const context = await browser.newContext({ viewport: { width: 1400, height: 1000 } });
		try {
			const page = await context.newPage();
			const url = `${BASE_URL}/${file}?pbs=on`;
			await page.goto(url, { waitUntil: "domcontentloaded", timeout: 60_000 });
			await page.evaluate(() => document.fonts.ready);

			let data = null;
			for (let attempt = 1; attempt <= MAX_TEXTCONTENT_ATTEMPTS; attempt++) {
				data = await page.evaluate(() => {
					const textcontent = document.querySelector("#textcontent");
					if (!textcontent) return null;
					// Un-hide the short-info entries we'll reuse in the sidebar — they're
					// normally revealed on hover, not by ?pbs=on. Some also carry a
					// dynamically-set inline margin-top (the site's own on-page
					// alignment against their marker's scroll position), which is
					// meaningless once reused in our own absolutely-positioned sidebar
					// and would otherwise push them far outside the visible area — the
					// whole style attribute is dropped, not just display. On
					// absatz_*.html these also link out to the corresponding
					// topographical-transcription witness page ("Beginn Blatt 1 |
					// Topographische Umschrift"), which the sidebar must not carry —
					// that link is stripped here, along with the "| " separator it
					// leaves dangling.
					const pbInfos = [...document.querySelectorAll("#infocolumn > div.pagebreaks.pb_signet_background")].map(
						(el) => {
							const clone = el.cloneNode(true);
							clone.removeAttribute("style");
							clone.querySelector("a")?.remove();
							const span = clone.querySelector("span") ?? clone;
							span.innerHTML = span.innerHTML.replace(/\s*\|\s*$/, "");
							const pageNumber = span.textContent.match(/Beginn Blatt\s*\[?(\d+[a-zA-Z]?)\]?/)?.[1] ?? null;
							return { id: el.dataset.xmlid, html: clone.outerHTML, pageNumber };
						},
					);
					const firstMarker = textcontent.querySelector("span.pagebreaks.entity[id]");
					const pbsActive = !firstMarker || getComputedStyle(firstMarker).display !== "none";
					return { html: textcontent.innerHTML, pbInfos, pbsActive };
				});
				if (data) break;
				if (attempt < MAX_TEXTCONTENT_ATTEMPTS) {
					console.warn(
						`[warn] ${file}: no #textcontent found (attempt ${attempt}/${MAX_TEXTCONTENT_ATTEMPTS}) — retrying in ${TEXTCONTENT_RETRY_DELAY_MS}ms`,
					);
					await page.waitForTimeout(TEXTCONTENT_RETRY_DELAY_MS);
				}
			}
			if (!data) {
				throw new Error(
					`${file}: no #textcontent found after ${MAX_TEXTCONTENT_ATTEMPTS} attempts — aborting (no Absatz may be silently skipped)`,
				);
			}
			if (!data.pbsActive) {
				throw new Error(
					`${file}: pagebreak markers are still display:none with ?pbs=on — the annotation toggle didn't ` +
						`take effect before capture (check init-micro-editor's URL-param handling / timing)`,
				);
			}
			const label = file === "motto.html" ? "Motto" : `Absatz ${file.match(/\d+/)[0]}`;
			sourcePages.push({ file, label, html: data.html, pbInfos: data.pbInfos });
		} finally {
			await context.close();
		}
	}
	if (sourcePages.length === 0) {
		throw new Error("collected 0 source pages — start page unreachable?");
	}
	return sourcePages;
}

// --- Phase 2: assemble the collected fragments into one continuous flow on a
// live copy of the site (so its own stylesheet, fonts and asset paths — e.g.
// the pagebreak signet icon — resolve exactly as on the real site), build the
// persistent page-frame/clip/sidebar/footer structure renderPage() will reuse
// for every output page, then measure: every visual line's bottom edge (safe
// page-cut points), every pagebreak marker's top offset (for the sidebar),
// and every source fragment's top offset (for per-page footer attribution). ---
async function assembleAndMeasure(page, sourcePages) {
	await page.goto(`${BASE_URL}/motto.html?pbs=on`, { waitUntil: "domcontentloaded", timeout: 60_000 });
	await page.evaluate(() => document.fonts.ready);

	// Shrink the reading text one step via the site's own zoom-out control
	// (wpn-text-zoom-button.ts: decrements #textcontent's font-size by 1px per
	// click) before capturing anything — it only touches #textcontent's own
	// inline style, which our later-extracted innerHTML wouldn't carry, so the
	// resulting size is read back and reapplied explicitly below.
	await page.click("wpn-text-zoom-button[zoom-direction='out']");
	const textFontSize = await page.evaluate(() => document.querySelector("#textcontent").style.fontSize);

	// Hiding everything under <body> except our own frame (rather than listing
	// out nav/footer/aside/etc.) also covers whatever #textcontent's now-empty
	// former ancestors (<main>, #textcolumn, ...) leave behind.
	await page.addStyleTag({
		content: `
			html, body { margin: 0 !important; padding: 0 !important; }
			body > *:not(#lesefassung-page-frame) { display: none !important; }
		`,
	});

	const pbInfoById = new Map();
	for (const src of sourcePages) {
		for (const info of src.pbInfos) pbInfoById.set(info.id, info);
	}

	// data-* attributes (not classes) so these boundary markers can't collide
	// with anything the site's own CSS/JS matches on.
	const flowHtml = sourcePages
		.map(
			(src) =>
				`<div data-lesefassung-src="${escapeHtml(src.file)}" data-lesefassung-label="${escapeHtml(src.label)}">${src.html}</div>`,
		)
		.join("");

	await page.evaluate(
		({ flowHtml, dims }) => {
			// The real, single-page #textcontent is still in the (now-hidden) DOM
			// at this point; remove it so the id is unambiguous once our own
			// concatenated #textcontent below is queried by that same id.
			document.querySelector("#textcontent")?.remove();

			const pageFrame = document.createElement("div");
			pageFrame.id = "lesefassung-page-frame";
			pageFrame.style.cssText = `
				position: fixed; top: 0; left: 0;
				width: ${dims.pageWidthCm}cm; height: ${dims.pageHeightCm}cm;
				background: #ffffff; overflow: hidden;
			`;

			const clip = document.createElement("div");
			clip.id = "lesefassung-clip";
			clip.style.cssText = `
				position: absolute; top: ${dims.marginTopCm}cm; left: ${dims.marginLeftCm}cm;
				width: ${dims.textWidthCm}cm; height: ${dims.contentAreaHeightCm}cm; overflow: hidden;
			`;
			pageFrame.appendChild(clip);

			// A bare <wpn-text-view> ancestor (not the upgraded original custom
			// element) is enough to keep the site's own
			// `wpn-text-view .pagebreaks.entity.pbs::after` "||" indicator working,
			// since that's a plain CSS descendant selector.
			const shell = document.createElement("wpn-text-view");
			clip.appendChild(shell);
			const flow = document.createElement("div");
			flow.id = "lesefassung-flow";
			flow.style.cssText = `position: absolute; top: 0px; left: 0; width: ${dims.textWidthPx}px;`;
			const textcontent = document.createElement("div");
			textcontent.id = "textcontent";
			textcontent.className = "ff-crimson-text";
			textcontent.style.fontSize = dims.textFontSize;
			textcontent.innerHTML = flowHtml;
			flow.appendChild(textcontent);
			shell.appendChild(flow);

			const sidebar = document.createElement("div");
			sidebar.id = "lesefassung-sidebar";
			sidebar.style.cssText = `
				position: absolute; top: ${dims.marginTopCm}cm;
				left: ${dims.marginLeftCm + dims.textWidthCm + dims.sidebarGutterCm}cm;
				width: ${dims.sidebarWidthCm}cm; height: ${dims.contentAreaHeightCm}cm; overflow: hidden;
			`;
			pageFrame.appendChild(sidebar);

			const footer = document.createElement("div");
			footer.id = "lesefassung-footer";
			footer.style.cssText = `
				position: absolute; left: ${dims.marginLeftCm}cm; right: ${dims.marginRightCm}cm; bottom: 0;
				height: ${dims.footerHeightCm}cm; display: flex; align-items: center; justify-content: space-between;
				font-family: Arial, Helvetica, sans-serif; font-size: 8px; color: #555555;
			`;
			const footerLeft = document.createElement("span");
			footerLeft.id = "lesefassung-footer-left";
			const footerLink = document.createElement("a");
			footerLink.id = "lesefassung-footer-link";
			footerLink.style.color = "#555555";
			footerLeft.appendChild(footerLink);
			footerLeft.appendChild(document.createTextNode(""));
			const footerRight = document.createElement("span");
			footerRight.id = "lesefassung-footer-right";
			footer.appendChild(footerLeft);
			footer.appendChild(footerRight);
			pageFrame.appendChild(footer);

			document.body.appendChild(pageFrame);
		},
		{
			flowHtml,
			dims: {
				pageWidthCm: PAGE_WIDTH_CM,
				pageHeightCm: PAGE_HEIGHT_CM,
				marginTopCm: MARGIN_TOP_CM,
				marginLeftCm: MARGIN_LEFT_CM,
				marginRightCm: MARGIN_RIGHT_CM,
				textWidthCm: TEXT_WIDTH_CM,
				textWidthPx: TEXT_WIDTH_PX,
				sidebarGutterCm: SIDEBAR_GUTTER_CM,
				sidebarWidthCm: SIDEBAR_WIDTH_CM,
				contentAreaHeightCm: CONTENT_AREA_HEIGHT_CM,
				footerHeightCm: FOOTER_HEIGHT_CM,
				textFontSize,
			},
		},
	);
	await page.evaluate(() => document.fonts.ready);

	const layout = await page.evaluate(() => {
		const root = document.querySelector("#textcontent");
		const rootTop = root.getBoundingClientRect().top;

		// A single visual line can be reported as several client rects with
		// slightly different bottoms (e.g. a line containing an inline entity
		// span with its own metrics) — merge overlapping rects into line bands
		// first, or a cut could land between two fragments of what is actually
		// one line and duplicate that line's tail onto the next page.
		const range = document.createRange();
		range.selectNodeContents(root);
		// Range.getClientRects() can include a spurious rect spanning the whole
		// selection (observed at the very start, top:0, height == root's entire
		// height) alongside the real one-rect-per-line results — discard
		// anything taller than a real line could plausibly be.
		const rects = [...range.getClientRects()]
			.map((r) => ({ top: r.top - rootTop, bottom: r.bottom - rootTop }))
			.filter((r) => r.bottom - r.top < 60)
			.sort((a, b) => a.top - b.top);
		// Standard merge-overlapping-intervals, sorted by top: a rect starts a
		// new line only once it begins at/after the current band's bottom edge;
		// ANY overlap (even a fraction of a px, as from e.g. a wpn-entity span
		// with slightly different line-box metrics) means it's a fragment of
		// the same visual line and must extend the current band instead of
		// starting a new one — getting this backwards is what let two rects of
		// one real line be treated as separate lines, causing a page cut to
		// land mid-line (the tail then re-rendered in full on the next page).
		const lineBottoms = [];
		let bandBottom = null;
		for (const r of rects) {
			if (bandBottom !== null && r.top < bandBottom - 0.1) {
				bandBottom = Math.max(bandBottom, r.bottom);
			} else {
				if (bandBottom !== null) lineBottoms.push(Math.round(bandBottom * 100) / 100);
				bandBottom = r.bottom;
			}
		}
		if (bandBottom !== null) lineBottoms.push(Math.round(bandBottom * 100) / 100);

		const sources = [...root.querySelectorAll(":scope > [data-lesefassung-src]")].map((el) => ({
			file: el.dataset.lesefassungSrc,
			label: el.dataset.lesefassungLabel,
			top: el.getBoundingClientRect().top - rootTop,
		}));

		const markers = [...root.querySelectorAll("span.pagebreaks.entity[id]")].map((el) => ({
			id: el.id,
			top: el.getBoundingClientRect().top - rootTop,
		}));

		// Not root.scrollHeight: it can round up a fraction of a pixel past the
		// last real lineBottom, and packPages() would then dedicate an entire
		// trailing page to that sliver of nothing.
		const totalHeightPx = lineBottoms.at(-1) ?? 0;

		return { lineBottoms, sources, markers, totalHeightPx };
	});

	return { ...layout, pbInfoById };
}

// --- Phase 3: pack the measured lines into page-height windows, cutting only
// at a line's bottom edge (never mid-line) and letting the next Absatz start
// wherever the previous one's last line landed. ---
function packPages(layout) {
	const { lineBottoms, totalHeightPx } = layout;
	const windows = [];
	let cursor = 0;
	while (cursor < totalHeightPx - 0.5) {
		const target = cursor + CONTENT_AREA_HEIGHT_PX;
		let cut = null;
		for (const b of lineBottoms) {
			if (b > cursor + 0.5 && b <= target) cut = b;
			if (b > target) break;
		}
		if (cut === null) {
			// A single line taller than the whole content area (shouldn't happen
			// with this typography) — force progress instead of looping forever.
			cut = lineBottoms.find((b) => b > cursor + 0.5) ?? totalHeightPx;
			console.warn(`[warn] no line fits within one page at offset ${cursor.toFixed(0)}px — forcing a cut at ${cut.toFixed(0)}px`);
		}
		windows.push([cursor, cut]);
		cursor = cut;
		if (windows.length > MAX_OUTPUT_PAGES) {
			throw new Error(`exceeded ${MAX_OUTPUT_PAGES} pages — pagination is probably not making progress`);
		}
	}
	return windows;
}

// --- Phase 4: render one page for a given [start, end) window: shift the
// flow up by `start`, drop in the matching sidebar entries and footer, export. ---
async function renderPage(page, [start, end], layout) {
	const { sources, markers, pbInfoById } = layout;

	// "The Absatz shown on the page, or — if a new one begins — that new one":
	// the most recently started source whose start falls at/before the end of
	// this page's window.
	const activeSource = [...sources].reverse().find((s) => s.top <= end + 0.5) ?? sources[0];

	// "The first page-number located on the page", falling back to whichever
	// pagebreak was still active when this page began (nothing new started).
	const markersOnPage = markers.filter((m) => m.top >= start - 0.5 && m.top < end);
	const carriedMarker = [...markers].reverse().find((m) => m.top <= start + 0.5);
	const footerMarker = markersOnPage[0] ?? carriedMarker;
	const footerPageNumber = (footerMarker && pbInfoById.get(footerMarker.id)?.pageNumber) ?? "?";

	const sidebarItemsHtml = markersOnPage
		.map((m) => {
			const info = pbInfoById.get(m.id);
			if (!info) return "";
			const topCm = (m.top - start) / CM_TO_PX;
			return `<div style="position:absolute; top:${topCm}cm; left:0; right:0;">${info.html}</div>`;
		})
		.join("");

	const footerLeftUrl = `${BASE_URL}/${activeSource.file}`;
	const footerRightText = `${activeSource.label}, [${footerPageNumber}]`;

	await page.evaluate(
		({ start, end, sidebarItemsHtml, footerLeftUrl, dateStr, footerRightText }) => {
			document.getElementById("lesefassung-flow").style.top = `-${start}px`;
			// The clip box defaults to the full per-page budget (CONTENT_AREA_HEIGHT_CM),
			// but a page's actual content (end - start) is usually a bit less than
			// that budget — whatever line didn't fit stops just short of the
			// budget's edge. Left at the full budget height, the clip would still
			// show past the true cut and let that excluded line's top sliver peek
			// through. It must shrink to exactly this page's real content span.
			document.getElementById("lesefassung-clip").style.height = `${end - start}px`;
			document.getElementById("lesefassung-sidebar").innerHTML = sidebarItemsHtml;
			const link = document.getElementById("lesefassung-footer-link");
			link.href = footerLeftUrl;
			link.textContent = footerLeftUrl;
			document.getElementById("lesefassung-footer-left").lastChild.textContent = ` [${dateStr}]`;
			document.getElementById("lesefassung-footer-right").textContent = footerRightText;
		},
		{ start, end, sidebarItemsHtml, footerLeftUrl, dateStr: RUN_DATE, footerRightText },
	);

	await page.emulateMedia({ media: "screen" });
	const pdfBuffer = await page.pdf({
		width: `${PAGE_WIDTH_CM}cm`,
		height: `${PAGE_HEIGHT_CM}cm`,
		printBackground: true,
		margin: { top: 0, right: 0, bottom: 0, left: 0 },
	});

	const doc = await PDFDocument.load(pdfBuffer);
	if (doc.getPageCount() !== 1) {
		throw new Error(`Expected 1 PDF page for window [${start}, ${end}), got ${doc.getPageCount()}`);
	}
	return pdfBuffer;
}

main().catch((err) => {
	console.error(err);
	process.exitCode = 1;
});
