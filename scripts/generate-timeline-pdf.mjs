#!/usr/bin/env node
// Renders the Ereignisse-Timeline (the <wpn-time-line> AnyChart widget on
// timeline.html) into a single very wide PDF page at the timeline's highest
// useful zoom (fine day-level horizontal spacing), scaled so the smallest
// rendered label text comes out at roughly PDF_TIMELINE_TARGET_PT.
//
// Scope: the underlying data spans the year 37 (a Caligula anecdote) to
// October 1933, but all but a handful of "Historische Referenzen" entries
// fall inside 1914-1933, which is rendered as one dense, continuous run of
// events. Laying the *entire* 1900-year span out linearly at day-level
// spacing would need a canvas many meters wide just to fit in a dozen
// isolated antique data points — so only the dense period (from
// PDF_TIMELINE_DENSE_START on) is drawn on the timeline itself; the older
// outliers are listed instead on a plain appendix page, using the exact
// title/date/category text already rendered (for the on-site detail popover)
// in each event's #details_DWCeventNNNN node, rather than reformatting the
// source dates ourselves.
//
// Not paginated like generate-pdfs.mjs / generate-lesefassung-pdf.mjs: this
// produces ONE page whose physical size is derived from how much time the
// dense period covers, per the horizontal pixel-per-day density below —
// intentionally, at the user's request, rather than a fixed page size.
//
// Usage:  node scripts/generate-timeline-pdf.mjs
// Env:    PDF_BASE_URL                 base URL of the site (default: production)
//         PDF_TIMELINE_DENSE_START     ISO date; events before this go to the
//                                      appendix page instead of the timeline
//                                      (default: 1914-01-01)
//         PDF_TIMELINE_PX_PER_DAY      horizontal pixel density for the dense
//                                      period at 100% (default: 5, ~matches
//                                      the site's own default ~6-month view:
//                                      850px / 182 days ~= 4.7px/day)
//         PDF_TIMELINE_TARGET_PT       target size, in pt, for the smallest
//                                      rendered label font (default: 8)
//         PDF_TIMELINE_MAX_WIDTH_CM    safety cap on the page width before
//                                      the 8pt-fit scaling is applied
//                                      (default: 1200 ~= 12m); if hit, the
//                                      requested px/day density could not be
//                                      honored in full and a warning is
//                                      logged — lower PDF_TIMELINE_PX_PER_DAY
//                                      instead of raising this unless you've
//                                      confirmed Chromium can print it

import { chromium } from "@playwright/test";
import { PDFDocument } from "pdf-lib";
import { mkdir, readFile, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { CM_TO_PX, RUN_DATE_ISO, escapeHtml, generateCoverPage, mergePdfs } from "./pdf-shared.mjs";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const OUT_DIR = path.join(ROOT, "pdf-output");
const OUT_PATH = path.join(OUT_DIR, process.env.PDF_TIMELINE_OUT ?? "Timeline.pdf");
const DATA_PATH = path.join(ROOT, "wpn-utils", "timeline_data", "timeline_data.json");

const BASE_URL = (process.env.PDF_BASE_URL ?? "https://karl-kraus.github.io/wpn-static-dev").replace(/\/$/, "");
const DENSE_START = process.env.PDF_TIMELINE_DENSE_START ?? "1914-01-01";
const PX_PER_DAY = Number(process.env.PDF_TIMELINE_PX_PER_DAY ?? 5);
const TARGET_FONT_PT = Number(process.env.PDF_TIMELINE_TARGET_PT ?? 8);
const MAX_WIDTH_CM = Number(process.env.PDF_TIMELINE_MAX_WIDTH_CM ?? 1200);

// 96 css px/inch, 72pt/inch -> 1px = 0.75pt.
const PT_PER_PX = 0.75;

const YEAR_ONLY = /^\d{4}$/;

async function main() {
	await mkdir(OUT_DIR, { recursive: true });
	console.log(`Base URL: ${BASE_URL}`);

	const { denseStartMs, domainEndMs, historicalIds } = await loadAndSplitData();
	console.log(
		`Dense period on the timeline: ${new Date(denseStartMs).toISOString().slice(0, 10)} – ` +
			`${new Date(domainEndMs).toISOString().slice(0, 10)} ` +
			`(${historicalIds.length} older event(s) moved to the appendix page)`,
	);

	const browser = await chromium.launch();
	try {
		const context = await browser.newContext({ viewport: { width: 1400, height: 1000 } });
		try {
			const page = await context.newPage();
			await page.goto(`${BASE_URL}/timeline.html`, { waitUntil: "domcontentloaded", timeout: 60_000 });
			await page.waitForFunction(
				() => {
					const el = document.querySelector("#timeline_container");
					return !!(el && el.chart);
				},
				{ timeout: 30_000 },
			);
			await page.evaluate(() => document.fonts.ready);

			// Appendix content is extracted from this same page's own (normally
			// hidden, hover-revealed) detail-view registry entries — reuses the
			// site's own date/title formatting instead of reimplementing it.
			const historicalEntries = await extractHistoricalEntries(page, historicalIds);

			console.log("Isolating and resizing the chart...");
			const { widthPx, heightPx, minFontPx, widthClamped } = await layoutTimeline(page, {
				denseStartMs,
				domainEndMs,
				pxPerDay: PX_PER_DAY,
				maxWidthPx: MAX_WIDTH_CM * CM_TO_PX,
			});
			if (widthClamped) {
				console.warn(
					`[warn] requested width exceeded PDF_TIMELINE_MAX_WIDTH_CM (${MAX_WIDTH_CM}cm) and was capped — ` +
						`the dense period no longer gets the full ${PX_PER_DAY}px/day; lower PDF_TIMELINE_PX_PER_DAY ` +
						`or raise PDF_TIMELINE_MAX_WIDTH_CM if that's not acceptable.`,
				);
			}

			const scale = minFontPx ? (TARGET_FONT_PT / PT_PER_PX) / minFontPx : 1;
			if (!minFontPx) {
				console.warn("[warn] could not measure any label font size — skipping the 8pt-fit scaling (scale=1)");
			}
			const finalWidthPx = widthPx * scale;
			const finalHeightPx = heightPx * scale;
			console.log(
				`Natural size ${widthPx.toFixed(0)}x${heightPx.toFixed(0)}px, smallest label ` +
					`${minFontPx ? `${minFontPx.toFixed(1)}px (${(minFontPx * PT_PER_PX).toFixed(1)}pt)` : "n/a"} -> ` +
					`scale ${scale.toFixed(3)} -> final page ${(finalWidthPx / CM_TO_PX).toFixed(1)}x` +
					`${(finalHeightPx / CM_TO_PX).toFixed(1)}cm`,
			);

			const timelinePdfBytes = await renderTimelinePage(page, { widthPx, heightPx, scale });

			const citation =
				`Karl Kraus: Dritte Walpurgisnacht. Ereignisse-Timeline ` +
				`(${new Date(denseStartMs).getUTCFullYear()}–${new Date(domainEndMs).getUTCFullYear()}). ` +
				`Digitale Edition. Hg. v. Bernhard Oberreither. ` +
				`<a href="${escapeHtml(BASE_URL)}/timeline.html">${escapeHtml(BASE_URL)}/timeline.html</a>` +
				`<br/>[Stand ${RUN_DATE_ISO}]` +
				(historicalEntries.length > 0
					? `<br/><br/><span style="font-size:10pt">Ereignisse vor ${new Date(denseStartMs).getUTCFullYear()} ` +
						`s. Anhang.</span>`
					: "");
			const coverBytes = await generateCoverPage(browser, citation);

			const pdfParts = [coverBytes, timelinePdfBytes];
			if (historicalEntries.length > 0) {
				pdfParts.push(await generateAppendixPage(browser, historicalEntries, new Date(denseStartMs).getUTCFullYear()));
			}

			const merged = await mergePdfs(pdfParts);
			await writeFile(OUT_PATH, merged);
			console.log(`[done] Timeline -> ${OUT_PATH}`);
		} finally {
			await context.close();
		}
	} finally {
		await browser.close();
	}
}

// --- Data: figure out the dense-period bounds and which event ids fall
// before it, straight from the same JSON the chart itself loads (see
// wpn-utils/wpn-timeline.ts) rather than re-deriving this from the DOM. ---
async function loadAndSplitData() {
	const raw = await readFile(DATA_PATH, "utf-8");
	const data = JSON.parse(raw);

	// Mirrors wpn-timeline.ts's own year-only normalization so start/end here
	// match what the chart actually plots.
	for (const item of data.rangeData) {
		if (YEAR_ONLY.test(item.end)) item.end = `${item.end}-12-31`;
		if (YEAR_ONLY.test(item.start)) item.start = `${item.start}-01-01`;
	}

	// Only items with at least one category are ever plotted (see the
	// .filter((item) => item.categories.length > 0) in wpn-timeline.ts).
	const rangeItems = data.rangeData.filter((item) => item.categories.length > 0);
	const momentItems = data.momentData.filter((item) => item.categories.length > 0);

	const cutoffMs = Date.parse(DENSE_START);
	if (Number.isNaN(cutoffMs)) {
		throw new Error(`PDF_TIMELINE_DENSE_START="${DENSE_START}" is not a valid ISO date`);
	}

	// A range item's own start decides which side of the cutoff it falls on
	// (none of the source data straddles it, but start is the conservative
	// choice if that ever changes: an item beginning before the cutoff still
	// reads as a "historical" outlier even if it technically ends after it).
	const historicalIds = [
		...rangeItems.filter((item) => Date.parse(item.start) < cutoffMs).map((item) => item.id),
		...momentItems.filter((item) => Date.parse(item.x) < cutoffMs).map((item) => item.id),
	];

	const allEndMs = [
		...rangeItems.map((item) => Date.parse(item.end)),
		...momentItems.map((item) => Date.parse(item.x)),
	];
	const domainEndMs = Math.max(...allEndMs);

	return { denseStartMs: cutoffMs, domainEndMs, historicalIds };
}

// --- Pull each historical event's already-formatted title/date/category
// text out of its (normally hover-revealed) #details_<id> registry node. ---
async function extractHistoricalEntries(page, ids) {
	return page.evaluate((ids) => {
		return ids
			.map((id) => {
				const root = document.querySelector(`#details_${id}`);
				if (!root) return null;
				const title = root.querySelector(`[data-testid="comment_label_${id}"]`)?.innerHTML.trim() ?? id;
				const date = root.querySelector(`[data-testid="event_date_${id}"]`)?.textContent.trim() ?? "";
				const categories = [...root.querySelectorAll(`[data-testid="category_list_${id}"] li`)]
					.map((li) => li.textContent.trim())
					.join(", ");
				return { id, title, date, categories };
			})
			.filter(Boolean);
	}, ids);
}

// --- Isolate the chart, zoom it to the dense period at the requested
// pixel-per-day density, force a redraw at that size, and measure the
// resulting box plus the smallest font size among its rendered labels. ---
async function layoutTimeline(page, { denseStartMs, domainEndMs, pxPerDay, maxWidthPx }) {
	await page.addStyleTag({
		content: `
			#primary_nav, nav[aria-label="breadcrumb"], footer.footer, aside, .modal, .modal-backdrop,
			#first-visit-info-overlay {
				display: none !important;
			}
			html, body, .wrapper, .d-flex.flex-row, main, .m-5 {
				margin: 0 !important;
				padding: 0 !important;
				width: auto !important;
				max-width: none !important;
				flex: none !important;
				overflow: visible !important;
			}
		`,
	});

	const requestedWidthPx = Math.round(((domainEndMs - denseStartMs) / 86_400_000) * pxPerDay);
	const widthPx = Math.min(requestedWidthPx, Math.round(maxWidthPx));
	const widthClamped = widthPx < requestedWidthPx;

	const { heightPx, minFontPx } = await page.evaluate(
		({ denseStartMs, domainEndMs, widthPx }) => {
			const container = document.querySelector("#timeline_container");
			const chart = container.chart;
			chart.scroller().enabled(false);
			chart.zoomTo(denseStartMs, domainEndMs);
			container.style.setProperty("width", `${widthPx}px`, "important");
			chart.draw();

			// Smallest computed font-size among every element that directly
			// carries text — covers both the useHtml(true) series labels
			// (plain HTML spans inside a <foreignObject>) and AnyChart's own
			// native SVG <text>/<tspan> axis labels; getComputedStyle resolves
			// font-size on SVG text elements the same way it does on HTML ones.
			let minFontPx = null;
			const walker = document.createTreeWalker(container, NodeFilter.SHOW_ELEMENT);
			let el;
			while ((el = walker.nextNode())) {
				const hasOwnText = [...el.childNodes].some((n) => n.nodeType === 3 && n.textContent.trim().length > 0);
				if (!hasOwnText) continue;
				const fs = parseFloat(getComputedStyle(el).fontSize);
				if (fs > 0 && (minFontPx === null || fs < minFontPx)) minFontPx = fs;
			}

			return { heightPx: container.getBoundingClientRect().height, minFontPx };
		},
		{ denseStartMs, domainEndMs, widthPx },
	);

	return { widthPx, heightPx, minFontPx, widthClamped };
}

// --- Fix the now-correctly-sized chart to the top-left corner of the
// viewport, scale it to hit the target font size, and export at exactly that
// physical size — same position:fixed-frame + exact page.pdf({width,height})
// technique used by pdf-shared.mjs's cover page and the Lesefassung script. ---
async function renderTimelinePage(page, { widthPx, heightPx, scale }) {
	const finalWidthPx = widthPx * scale;
	const finalHeightPx = heightPx * scale;

	await page.evaluate(
		({ finalWidthPx, finalHeightPx, scale }) => {
			const container = document.querySelector("#timeline_container");
			container.style.setProperty("position", "fixed", "important");
			container.style.setProperty("top", "0", "important");
			container.style.setProperty("left", "0", "important");
			container.style.setProperty("transform", `scale(${scale})`, "important");
			container.style.setProperty("transform-origin", "top left", "important");
			container.style.setProperty("background", "#ffffff", "important");

			for (const el of [document.documentElement, document.body]) {
				el.style.setProperty("width", `${finalWidthPx}px`, "important");
				el.style.setProperty("height", `${finalHeightPx}px`, "important");
				el.style.setProperty("margin", "0", "important");
				el.style.setProperty("padding", "0", "important");
				el.style.setProperty("overflow", "hidden", "important");
			}
		},
		{ finalWidthPx, finalHeightPx, scale },
	);

	await page.emulateMedia({ media: "screen" });
	const pdfBuffer = await page.pdf({
		width: `${finalWidthPx}px`,
		height: `${finalHeightPx}px`,
		printBackground: true,
		margin: { top: 0, right: 0, bottom: 0, left: 0 },
	});

	const doc = await PDFDocument.load(pdfBuffer);
	if (doc.getPageCount() !== 1) {
		throw new Error(`Expected 1 PDF page for the timeline, got ${doc.getPageCount()}`);
	}
	return pdfBuffer;
}

// --- Plain A4-flow appendix listing the older, off-timeline events, styled
// like pdf-shared.mjs's own cover page (not the site's on-screen "Registerein-
// trag" cards, which lean on hover-only positioning/background icons that
// don't make sense outside their popover context). Lets Chromium paginate
// this normally rather than forcing it onto one page. ---
async function generateAppendixPage(browser, entries, denseStartYear) {
	const context = await browser.newContext();
	try {
		const page = await context.newPage();
		const itemsHtml = entries
			.map(
				(e) => `<li style="margin-bottom:0.6cm;">
					<span style="font-weight:600;">${e.title}</span>
					<span style="color:#666666;">(${escapeHtml(e.date)}${e.categories ? `, ${escapeHtml(e.categories)}` : ""})</span>
				</li>`,
			)
			.join("");
		await page.setContent(`<!doctype html>
<html><head><meta charset="utf-8"><style>
  body { font-family: Georgia, 'Times New Roman', serif; margin: 2.5cm 3cm; color: #111111; font-size: 11pt; line-height: 1.5; }
  h1 { font-size: 13pt; font-weight: normal; margin-bottom: 1cm; }
  ul { list-style: none; padding: 0; margin: 0; }
</style></head>
<body>
  <h1>Historische Referenzen vor ${denseStartYear} (nicht im Zeitstrahl dargestellt)</h1>
  <ul>${itemsHtml}</ul>
</body></html>`);
		const pdfBuffer = await page.pdf({ format: "A4", printBackground: true });
		return pdfBuffer;
	} finally {
		await context.close();
	}
}

main().catch((err) => {
	console.error(err);
	process.exitCode = 1;
});
