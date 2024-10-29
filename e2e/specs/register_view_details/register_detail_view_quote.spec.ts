/* eslint-disable playwright/no-conditional-expect */
/* eslint-disable playwright/no-conditional-in-test */
import { expect, test } from "@playwright/test";

import type { TestDataObjectIntertextRegister } from "../../src/interfaces.js";
import { fetchTestData } from "../../utils/helpers.js";



for (let i = 65; i <= 90; i++) {
	const letter = String.fromCharCode(i);
	const testData: Array<TestDataObjectIntertextRegister> = await fetchTestData(`quote_register_detail_view_${letter}.json`);
	testData.forEach((testObject: TestDataObjectIntertextRegister) => {
		test(`register entries match for letter ${letter} ${testObject.sortkey} ${testObject.id}`, async ({ page }) => {
			await page.goto(`http://localhost:8000/html/register_intertexte.html?letter=${letter}#${testObject.id}`);
			await expect(page.getByTestId(`description_register_${testObject.id}`)).toHaveText(testObject.description);
			if (testObject.external_link) {
				const external_link = page.getByTestId(`external_link_register_${testObject.id}`);
				const external_link_label = page.getByTestId(`external_link_label_register_${testObject.id}`);
				const external_link_text = page.getByTestId(`external_link_text_register_${testObject.id}`);
				await expect(external_link).toHaveAttribute("href",testObject.external_link.href);
				await expect(external_link_label).toHaveText(testObject.external_link.label);
				await expect(external_link_text).toHaveText(testObject.external_link.text);
			}
			if (testObject.scan) {
				const scan_text = page.getByTestId(`scans_register_${testObject.id}`).locator("summary > span:nth-child(2)");
				await expect(scan_text).toHaveText(testObject.scan.text);
			}
		})
	})
}

