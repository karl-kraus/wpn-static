import { expect, test } from "@playwright/test";

import type { TestDataObjectPersonRegister } from "../../src/interfaces.js";
import { fetchTestData } from "../../utils/helpers.js";



for (let i = 65; i <= 90; i++) {
	const letter = String.fromCharCode(i);
	const testData: Array<TestDataObjectPersonRegister> = await fetchTestData(`person_list_view_${letter}.json`);
	testData.forEach((testObject: TestDataObjectPersonRegister) => {
		test(`register entries match for letter ${letter} ${testObject.sortkey} ${testObject.id}`, async ({ page }) => {
			await page.goto(`http://localhost:8000/html/register_personen.html?letter=${letter}`);
			await expect(page.locator(`#${letter}-pane`)).toBeVisible();
			await expect(page.getByTestId(`register_short_info_${letter}_${testObject.sortkey}_${testObject.id}`)).toHaveText(testObject.description);
		})
	})
}

