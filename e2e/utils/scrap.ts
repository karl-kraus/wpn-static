import { writeFile } from "node:fs";

import { chromium, expect } from "@playwright/test";

const letter = "Z";

void (async () => {
	const browser = await chromium.launch();
	const context = await browser.newContext();
	const page = await context.newPage();

	await page.goto(
		`https://kraus1933.ace.oeaw.ac.at/Gesamt.xml?template=register_intertexte.html&letter=${letter}`,
	);
	const rendered_content = [];
	await expect(page.locator(".regentry").first()).toBeVisible();

	for (const regEntry of await page.locator(".regentry").all()) {
		const text = await regEntry.innerText();
		rendered_content.push(text);
	}

	writeFile(
		`${__dirname}/tests/data/intertext_list_view_${letter}.txt`,
		rendered_content.join("\n"),
		(err) => {
			if (err) {
				console.error(err);
			} else {
				// file written successfully
			}
		},
	);
	void browser.close();
})();
