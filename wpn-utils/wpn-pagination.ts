class WPNPagination extends HTMLElement {
	citationURLElement = this.querySelector("#citation-url");

	observer = new MutationObserver((mutationRecords) => {
		mutationRecords.forEach((mutationRecord) => {
			if (mutationRecord.attributeName === "href") {
				const currentURL = new URL((mutationRecord.target as HTMLAnchorElement).href);
				const searchParams = new URLSearchParams(currentURL.search);
				this.querySelectorAll(".page_link").forEach((pl) => {
					const currentHref = pl.getAttribute("href") ?? "";
					if (currentHref.includes("?")) {
						pl.setAttribute("href", currentHref.replace(/(?<=\?).*/, searchParams.toString()));
					} else {
						pl.setAttribute("href", `${currentHref}?${searchParams.toString()}`);
					}
				});
			}
		});
	});

	connectedCallback() {
		const citationURLElement = document.getElementById("citation-url");
		if (citationURLElement) {
			this.observer.observe(citationURLElement, { attributes: true });
		}
	}
}

customElements.define("wpn-pagination", WPNPagination);
