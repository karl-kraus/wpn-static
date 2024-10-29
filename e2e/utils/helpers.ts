import type { Page } from "@playwright/test";

export async function fetchTestData<T>(fileName: string): Promise<Array<T>> {
  let TestData: Array<T>;
  try {
    const data_module = await import(`../test-data/${fileName}`, { with: { type: "json" } }) as { default: Array<T> };
    TestData = data_module.default;
  } catch (err) {
    TestData = [];
  }
  return TestData;
}


export async function getListItems(page: Page, test_id: string, selectors: Array<string>) {
  const listItemsLocator = page.getByTestId(test_id).locator('li');
  const listItems = await listItemsLocator.evaluateAll((listItems, selectors) => {
    return Array.from(listItems).map((item) => {
      const listItem: Record<string, string> = {};

      if (selectors.length > 1) {
        listItem.label = item.querySelector(selectors[0])?.textContent ?? "";
        listItem.text = item.querySelector(selectors[1])?.textContent ?? "";
      } else {
        listItem.text = item.querySelector(selectors[0])?.textContent ?? "";
        listItem.href = item.querySelector(selectors[0])?.getAttribute("href") ?? "";
      }
      return listItem;
    });
  }, selectors);
  return listItems;
}
