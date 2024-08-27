class WPNTextView extends HTMLElement {
	calcMargin = (element: HTMLElement, source_offset: number) => {
		let offset = source_offset;
		if (element.previousElementSibling)
			while ((element = element.previousElementSibling as HTMLElement)) {
		if (!element.classList.contains("d-none")) {
				offset -= (parseInt(element.style.marginTop, 10) || 0) + element.offsetHeight;
			}
			}

		return Math.max(Math.min(offset, 0), offset, 0);
	};

	positionElements(annotationSelectors: string) {
		console.log("repositioned")
		Array.from(document.querySelectorAll(annotationSelectors)).forEach((el: Element) => {
			const element = el as HTMLElement;
			const elmId: string = el.getAttribute("id") ?? "";
			let offset: number =
				element.offsetTop - document.getElementsByTagName("wpn-header")[0].offsetHeight;
			console.log(offset, el.getAttribute("id") ?? "");
			offset += parseInt(getComputedStyle(el).lineHeight, 10) / 2;

			const infoElm: HTMLElement | null = document.querySelector(`div[data-xmlid='${elmId}']`);
			if (infoElm) {
				const calculatedMargin =
					this.calcMargin(infoElm, offset) - parseInt(getComputedStyle(el).lineHeight, 10) / 2;
				const margin = String(Math.max(Math.min(calculatedMargin, 0), calculatedMargin, 0));

				infoElm.style.marginTop = `${margin}px`;
			}
		});
	}

	connectedCallback() {
		const annotationSelectors = this.getAttribute("annotation-selectors") ?? "";
		this.positionElements(annotationSelectors);
		[...document.getElementsByTagName("annotation-slider")].forEach((aos) => {
			aos.addEventListener("click", () => {
				this.positionElements(".entity");
			});
		});

		this.addEventListener("stateChange", () => {
			console.log("state changed")
			this.positionElements(".entity")
		});
	}
}

customElements.define("wpn-text-view", WPNTextView);
