import { expect, test } from "@playwright/test";

const pathsToTest: Array<{ label: string; path: string }> = [
	{
		label: "[Motti]",
		path: "motti",
	},
];

for (let i = 1; i <= 64; i++) {
	pathsToTest.push({ label: `Absatz ${String(i)}`, path: `absatz_${String(i)}` });
}

pathsToTest.forEach(({ label, path }) => {
	test(`testing edition page for ${path}`, async ({ page }) => {
		test.slow();

		// gather screenshot(s) from production
		// https://github.com/microsoft/playwright/issues/24497
		/*	await page.goto(
		`https://kraus1933.ace.oeaw.ac.at/${path}`,
	)
  await page.locator("#cookie-bar-button").click()
  await expect(page.locator("#cookie-bar-button")).toBeHidden()
		await expect(page.locator("option[selected]")).toHaveText(label, { timeout: 15000 });
		await page.addStyleTag({ content: "app-header, #controls {display:none;}" });
		const viewportWidth = page.viewportSize()?.width;
		const textElement = page.locator("#textview #textcolumn");
		const textElemBox = await textElement.boundingBox();

		await page.screenshot({
			path: `e2e/specs/edition_view.spec.ts-snapshots/snapshot-${path.replace("_", "-")}-chromium-linux.png`,
			fullPage: true,
			clip: { x: 0, y: 0, width: Number(viewportWidth), height: Number(textElemBox?.height) },
		});
		*/
		// compare local page to screenshot(s) gathered above
		await page.goto(`http://localhost:8000/html/${path}.html`);
		const viewportWidth = page.viewportSize()?.width;
		const mainElement = page.locator("main");
		const textElemBox = await mainElement.boundingBox();
		await page.addStyleTag({ content: "wpn-header, #controls, footer {display:none !important;}" });
		await expect(page).toHaveScreenshot(`snapshot-${path}.png`, { fullPage: true, timeout: 10000,clip: { x: 0, y: 0, width: Number(viewportWidth), height: Number(textElemBox?.height) } });
	});
});
