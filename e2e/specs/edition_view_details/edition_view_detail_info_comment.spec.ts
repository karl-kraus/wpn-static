/* eslint-disable playwright/no-conditional-expect */
/* eslint-disable playwright/no-conditional-in-test */
import { expect, test } from "@playwright/test";

import type { TestDataObjectComment } from "../../src/interfaces.js";
import { fetchTestData, getListItems } from "../../utils/helpers.js";

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
	const testData: Array<TestDataObjectComment> = await fetchTestData(`comment_detail_view_${pathToTest.path}.json`);

	testData.forEach((detail_info) => {
		test(`testing edition page for ${pathToTest.label} (${detail_info.id})`, async ({ page }) => {
			await page.goto(`http://localhost:8000/html/${pathToTest.path}.html#${detail_info.id}`);

			const label_element = page.getByTestId(`comment_label_details_${detail_info.id}`);
			const long_desc_element = page.getByTestId(`description_long_details_${detail_info.id}`);
			const register_link = page.getByTestId(`register_link_details_${detail_info.id}`);

			await expect(label_element).toHaveText(detail_info.description);
			await expect(long_desc_element).toHaveText(detail_info.description_long);
			if (detail_info.external_links) {
				const listItems = await getListItems(page, `external_links_details_${detail_info.id}`, [
					"a",
				]);
				expect(listItems).toEqual(detail_info.external_links);
			}
			if (detail_info.comment_links) {
				const listItems = await getListItems(page, `comment_links_details_${detail_info.id}`, [
					"a",
				]);
				expect(listItems).toEqual(detail_info.comment_links);
			}
			if (detail_info.register_link) {
				await expect(register_link.locator("span:nth-child(2)")).toHaveText(detail_info.register_link.text);
				await expect(register_link).toHaveAttribute("href", detail_info.register_link.href);
			}
		});
	});
}
