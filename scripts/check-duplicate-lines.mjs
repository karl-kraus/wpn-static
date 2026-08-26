// One-off QA helper: scans a generated PDF for the "line duplicated across a
// page boundary" pagination bug — extracts text per page via pdftotext and
// flags any page whose last non-blank line equals the next page's first
// non-blank line.
import { execFileSync } from "node:child_process";
import { readFileSync, unlinkSync } from "node:fs";

const pdfPath = process.argv[2];
if (!pdfPath) {
	console.error("usage: node scripts/check-duplicate-lines.mjs <pdf-path>");
	process.exit(1);
}

const tmpTxt = `${pdfPath}.check.txt`;
execFileSync("pdftotext", ["-layout", pdfPath, tmpTxt]);
const raw = readFileSync(tmpTxt, "utf-8");
unlinkSync(tmpTxt);

const pages = raw.split("\f");
console.log(`${pages.length} pages extracted`);

function lines(page) {
	return page
		.split(/\r?\n/)
		.map((l) => l.trim())
		.filter((l) => l.length > 3); // skip blank lines and short noise (dashes etc. still length>3 mostly ok)
}

// A clipped line can lose its final punctuation glyph in text extraction (the
// glyph sits outside the clip rect), so compare with trailing punctuation
// stripped and treat a prefix/suffix match as a duplicate too.
function norm(l) {
	return l.replace(/[.,;:!?»«"'’]+$/, "").trim();
}

let flagged = 0;
for (let i = 0; i < pages.length - 1; i++) {
	const curLines = lines(pages[i]);
	const nextLines = lines(pages[i + 1]);
	if (curLines.length === 0 || nextLines.length === 0) continue;
	const lastLine = curLines.at(-1);
	const firstLine = nextLines[0];
	const a = norm(lastLine);
	const b = norm(firstLine);
	if (a === b || (a.length > 4 && b.length > 4 && (a.startsWith(b) || b.startsWith(a)))) {
		flagged++;
		console.log(`\n[DUPLICATE?] page ${i + 1} -> ${i + 2}`);
		console.log(`  end of page ${i + 1}: "${lastLine}"`);
		console.log(`  start of page ${i + 2}: "${firstLine}"`);
	}
}
console.log(`\n${flagged} suspected duplicate(s) found.`);
