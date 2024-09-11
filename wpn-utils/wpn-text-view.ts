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
		Array.from(document.querySelectorAll(annotationSelectors)).forEach((el: Element) => {
			const element = el as HTMLElement;
			const elmId: string = el.getAttribute("id") ?? "";
			let offset: number =
				element.offsetTop - document.getElementsByTagName("wpn-header")[0].offsetHeight;
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
				const btnsToDisableAttr = aos.getAttribute("data-disable-btns");
				const aosInput = aos.querySelector("input");
				if (btnsToDisableAttr) {
					const btnsToDisable = btnsToDisableAttr.split(",");
					btnsToDisable.forEach((btnOpt) => {
						const btn = document.querySelector(`[opt='${btnOpt}']`);
						if (btn) {
							const btnInput = btn.querySelector("input");
							if (aosInput?.checked && btnInput?.checked) {
								btnInput.click();
							}
						}
					});
				}
				if (!aosInput?.checked) {
					document.querySelectorAll(`[data-entity-type=${aos.getAttribute("opt")}]`).forEach((el)=>{
						el.classList.add('d-none');
					})
				}
				this.positionElements(".entity");
			});
		});

		this.addEventListener("stateChange", () => {
			this.positionElements(".entity")
		});
	}
}

customElements.define("wpn-text-view", WPNTextView);
