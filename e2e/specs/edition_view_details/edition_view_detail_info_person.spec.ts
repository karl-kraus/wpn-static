/* eslint-disable playwright/no-conditional-expect */
/* eslint-disable playwright/no-conditional-in-test */
import { expect, test } from "@playwright/test";

import type { TestDataObjectPerson } from "../../src/interfaces.js";
import {fetchTestData} from '../../utils/helpers.js';


const pathsToTest: Array<{ label: string; path: string }> = [
	{
		label: "[Motti]",
		path: "motti",
	},
];

for (let i = 1; i <= 64; i++) {
	pathsToTest.push({ label: `Absatz ${String(i)}`, path: `absatz_${String(i)}` });
};

for (const pathToTest of pathsToTest) {


	const testData: Array<TestDataObjectPerson> = await fetchTestData(`person_detail_view_${pathToTest.path}.json`);

	testData.forEach((detail_info) => {
		test(`testing edition page for ${pathToTest.label} (${detail_info.id})`, async ({ page }) => {
			await page.goto(`http://localhost:8000/html/${pathToTest.path}.html#${detail_info.id}`);
			const detail_info_element = page.getByTestId(`description_details_${detail_info.id}`);
			const gnd_link = page.getByTestId(`gnd_link_details_${detail_info.id}`)
			const register_link = page.getByTestId(`register_link_details_${detail_info.id}`);
			await expect(detail_info_element).toHaveText(detail_info.description);
			if (detail_info.gnd_link) {
				await expect(gnd_link.locator("span:first-child")).toHaveText(detail_info.gnd_link.label);
				await expect(gnd_link.locator("span:nth-child(2)")).toHaveText(detail_info.gnd_link.text);
				await expect(gnd_link).toHaveAttribute("href",detail_info.gnd_link.href);
			}
			await expect(register_link.locator("span:first-child")).toHaveText(detail_info.register_link.label);
			await expect(register_link.locator("span:nth-child(2)")).toHaveText(detail_info.register_link.text);
		});
	});
}