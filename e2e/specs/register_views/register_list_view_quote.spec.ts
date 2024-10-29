import { createReadStream } from "node:fs";
import { createInterface } from "node:readline";

import { expect, test } from "@playwright/test";

const letter = "A";
const rendered_content: Array<string> = [];

test("register entries match", async ({ page }) => {
	// Option 1: compare to current production instance
	/*
	await page.goto(
		`https://kraus1933.ace.oeaw.ac.at/Gesamt.xml?template=register_intertexte.html&letter=${letter}`,
	);
	await expect(page.locator(".regentry").first()).toBeVisible();

	for (const regEntry of await page.locator(".regentry").all()) {
		const text = await regEntry.innerText();
		rendered_content.push(text);
	}*/

	// Option 2: compare to scrapped data from current production instance
	await page.goto("http://localhost:8000/html/register_intertexte.html");
	await expect(page.locator(`#${letter}`).first()).toBeVisible();
	const entries = await page.locator(`#${letter} > div`).all();
	for (const regEntry of entries) {
		const text = await regEntry.innerText();
		rendered_content.push(text);
	}

	//*https://nodejs.org/api/readline.html#example-read-file-stream-line-by-line
	const fileStream = createReadStream(
		`tests/data/intertext_list_view/intertext_list_view_${letter}.txt`,
	);

	const rl = createInterface({
		input: fileStream,
		crlfDelay: Infinity,
	});
	let i = 0;
	rl.on("line", (line) => {
		expect(rendered_content[i]).toEqual(line);
		i++;
	});
});
