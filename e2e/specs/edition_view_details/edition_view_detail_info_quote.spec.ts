/* eslint-disable playwright/no-conditional-expect */
/* eslint-disable playwright/no-conditional-in-test */
import { expect, test } from "@playwright/test";

import { fetchIntertextData, getListItems } from "../../utils/helpers.js";

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
	const testData = await fetchIntertextData(`quote_detail_view_${pathToTest.path}.json`);

	testData.forEach((detail_info) => {
		test(`testing edition page for ${pathToTest.label} (${detail_info.id})`, async ({ page }) => {
			await page.goto(`http://localhost:8000/html/${pathToTest.path}.html#${detail_info.id}`);
			const detail_info_element = page.getByTestId(`description_details_${detail_info.id}`);
			await expect(detail_info_element).toHaveText(detail_info.description);
			if (detail_info.external_links) {
				const listItems = await getListItems(page, `external_links_details_${detail_info.id}`, [
					"span",
					"a",
				]);
				expect(listItems).toEqual(detail_info.external_links);
			}

			if (detail_info.register_links) {
				const listItems = await getListItems(page, `register_links_details_${detail_info.id}`, [
					"span",
					"a",
				]);
				expect(listItems).toEqual(detail_info.register_links);
			}
			if (detail_info.text_excerpts) {
				const listItems = await getListItems(page, `text_excerpts_details_${detail_info.id}`, [
					"details summary span:first-child",
					"details summary span:nth-child(2)",
				]);
				expect(listItems).toEqual(detail_info.text_excerpts);
			}
			if (detail_info.scans) {
				const listItems = await getListItems(page, `scans_details_${detail_info.id}`, [
					"details summary span:first-child",
					"details summary span:nth-child(2)",
				]);
				expect(listItems).toEqual(detail_info.scans);
			}
		});
	});
}
