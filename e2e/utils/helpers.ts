import type { Page } from "@playwright/test";

import type { TestDataObjectIntertext,TestDataObjectPerson } from "../src/interfaces.js";


export async function fetchIntertextData(fileName: string) {
  const data_module = await import(`../test-data/${fileName}`, {with: {type: "json"}}) as {default: Array<TestDataObjectIntertext>};
  const TestData: Array<TestDataObjectIntertext> = data_module.default;
  return TestData;
};

export async function fetchPersonData(fileName: string) {
  const data_module = await import(`../test-data/${fileName}`, {with: {type: "json"}}) as {default: Array<TestDataObjectPerson>};
  const TestData: Array<TestDataObjectPerson> = data_module.default;
  return TestData;
};

export async function getListItems(page: Page, test_id: string, selectors: Array<string>) {
  const listItemsLocator = page.getByTestId(test_id).locator('li');
  const listItems = await listItemsLocator.evaluateAll((listItems, selectors) => {
    return Array.from(listItems).map((item) => {
      return {
        label: item.querySelector(selectors[0])?.textContent,
        text: item.querySelector(selectors[1])?.textContent,
      };
    });
  }, selectors);
  return listItems;
}
