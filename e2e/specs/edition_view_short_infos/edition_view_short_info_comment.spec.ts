/* eslint-disable playwright/no-conditional-expect */
/* eslint-disable playwright/no-conditional-in-test */
import { expect, test } from "@playwright/test";

import { fetchCommentData } from "../../utils/helpers.js";

const pathsToTest: Array<{ label: string; path: string }> = [
	{
		label: "[Motti]",
		path: "motti",
	},
];

for (let i = 1; i <= 64; i++) {
	pathsToTest.push({ label: `Absatz ${String(i)}`, path: `absatz_${String(i)}` });
}

for (const pathToTest of pathsToTest) {
	const testData = await fetchCommentData(`comment_short_info_${pathToTest.path}.json`);

	testData.forEach((detail_info) => {
		test(`testing edition page for ${pathToTest.label} (${detail_info.id})`, async ({ page }) => {
			await page.goto(`http://localhost:8000/html/${pathToTest.path}.html`);
			const info_element = page.getByTestId(`short_info_${detail_info.id}`);
			await expect(info_element).toHaveText(detail_info.description);
		});
	});
}
