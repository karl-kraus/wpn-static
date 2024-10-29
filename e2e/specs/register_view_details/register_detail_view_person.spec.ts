/* eslint-disable playwright/no-conditional-expect */
/* eslint-disable playwright/no-conditional-in-test */
import { expect, test } from "@playwright/test";

import type { TestDataObjectPersonRegister } from "../../src/interfaces.js";
import { fetchTestData } from "../../utils/helpers.js";



for (let i = 65; i <= 90; i++) {
	const letter = String.fromCharCode(i);
	const testData: Array<TestDataObjectPersonRegister> = await fetchTestData(`person_register_detail_view_${letter}.json`);
	testData.forEach((testObject: TestDataObjectPersonRegister) => {
		test(`register entries match for letter ${letter} ${testObject.sortkey} ${testObject.id}`, async ({ page }) => {
			const gnd_link = page.getByTestId(`gnd_link_${testObject.id}`);
			const pub_note = page.getByTestId(`pub_note_${testObject.id}`);
			await page.goto(`http://localhost:8000/html/register_personen.html?letter=${letter}#${testObject.id}`);
			await expect(page.getByTestId(`description_register_${testObject.id}`)).toHaveText(testObject.description);
			if (testObject.gnd_link) {
					await expect(gnd_link).toHaveAttribute("href",testObject.gnd_link);
			}
			if (testObject.pub_note) {
				await expect(pub_note).toHaveAttribute("data-bs-content",testObject.pub_note);
			}
		})
	})
}

