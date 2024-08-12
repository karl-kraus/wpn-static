import { createReadStream } from "node:fs";
import { createInterface } from "node:readline";

import { expect, test } from "@playwright/test";

const pathsToTest: Array<{label: string, path: string}> = [
		{
			label:'[Motti]', path: 'motti'
		},
]

for (let i = 1; i < 65; i++) {
	pathsToTest.push({label:`Absatz ${String(i)}`, path: `absatz_${String(i)}`});
}

pathsToTest.forEach(({label, path}) => {

test(`testing edition page for ${path}`, async ({ page }) => {
	test.slow()
	
	// gather screenshot(s) from production
	// https://github.com/microsoft/playwright/issues/24497
	/*	await page.goto(
		`https://kraus1933.ace.oeaw.ac.at/${path}`,
	)
  await page.locator("#cookie-bar-button").click()
  await expect(page.locator("#cookie-bar-button")).toBeHidden()
	await expect(page.locator('option[selected]')).toHaveText(label,{timeout:10000});
	
	await page.screenshot({path:`e2e/specs/edition_view.spec.ts-snapshots/snapshot-${path.replace('_','-')}-chromium-linux.png`,fullPage: true});*/
	
	// compare local page to screenshot(s) gathered above
	await page.goto(`http://localhost:8000/html/${path}.html`);
  await page.waitForTimeout(2000);
	await expect(page).toHaveScreenshot(`snapshot-${path}.png`,{threshold:0.7,fullPage: true, timeout: 10000});
	expect(1).toEqual(1)
	})
});
