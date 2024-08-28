// get text height to calculate the height of the header and footer
// page devided edition

const page = document!.querySelector('.print-page') as HTMLElement;
// console.log(page, page.offsetHeight);
const body = document.querySelector('.body-main')?.childNodes as NodeListOf<ChildNode>;
const header = document.querySelector('.print-header') as HTMLElement;
const footer = document.querySelector('.print-footer') as HTMLElement;

let textHeight = 0;
for (let child of body) {
	if (child.nodeName === "#text") continue;
	// console.log(child);
	textHeight += (child as HTMLElement).offsetHeight;
}

var headerHeight = (page.offsetHeight - textHeight) * 0.5;
var footerHeight = (page.offsetHeight - textHeight) * 0.5;
if (document.querySelector(".witnessTypescriptInsert") as HTMLElement) {
	headerHeight = page.offsetHeight * 0.081;
	footerHeight = (page.offsetHeight - textHeight) - (page.offsetHeight * 0.081);
}

header.style.height = `${headerHeight}px`;
footer.style.height = `${footerHeight}px`;
