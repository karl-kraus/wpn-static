import { expect, test } from "@playwright/test";
import { glob } from 'glob';
import path from 'path';


const editionTypoFiles = await glob('html/idPb*.html');

const pathsToTest = editionTypoFiles.map(f => path.basename(f))


pathsToTest.forEach((path ) => {
  test(`testing edition page for ${path}`, async ({ page }) => {
    test.slow();
   await page.setViewportSize({ width: 1880, height: 1000 });
    await page.goto(`http://localhost:8000/html/${path}`);
    const viewportWidth = page.viewportSize()?.width;
		const mainElement = page.locator("main");
		const textElemBox = await mainElement.boundingBox();
    await page.addStyleTag({ content: "wpn-header, #facscolumn, #infocolumn, footer {display:none !important;}" });
    await expect(page).toHaveScreenshot({fullPage: true, timeout: 10000,clip: { x: 0, y: 0, width: Number(viewportWidth), height: Number(textElemBox?.height) } });
  });
});
