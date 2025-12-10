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
		Array.from(document.querySelectorAll(`#textcolumn ${annotationSelectors}`)).forEach((el: Element) => {
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

	
	onLoadFinished = (annotationSelectors: string): void =>{
		let shortInfoElement;
		if(window.location.hash) {
			if (!(window.location.hash.startsWith('#pb') || window.location.hash.startsWith('#insertion'))) {
				shortInfoElement = document.querySelector(`a[href='${window.location.hash}']`);
				shortInfoElement?.parentElement?.classList.remove("d-none");
				const elementInText = document.querySelector(`#textcolumn wpn-entity#${window.location.hash.split("_")[0].substring(1)}`);
				const annotationClassName = [...elementInText?.classList].find(cn => cn.startsWith("annot_"));
				const annotationActiveClassName = `${annotationClassName}_active`;
				elementInText?.classList.replace(annotationClassName,annotationActiveClassName);
			}
		}
		this.positionElements(annotationSelectors);
		shortInfoElement?.scrollIntoView({block: "center"});
		window.removeEventListener('load',() => {
			this.positionElements(annotationSelectors)
		});
	}

	connectedCallback() {
		const annotationSelectors = this.getAttribute("annotation-selectors") ?? "";
		window.addEventListener('load',() => {
			this.onLoadFinished(annotationSelectors);
		});
		[...document.getElementsByTagName("annotation-slider")].forEach((aos) => {
			const annotClassName = [...aos.classList].find((cn) => cn.startsWith("text-wpn"));
      const entityName = annotClassName?.replace("text-wpn-",''); 
			aos.addEventListener("click", () => {
				 document.querySelectorAll(`wpn-entity[class*='annot_${entityName}_active']`).forEach(el=>{
          const annotationActiveClassName = [...el.classList].find(cn => cn.endsWith("_active"));
          if (annotationActiveClassName) {
            el.classList.remove(annotationActiveClassName);
          }
        })
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
				this.positionElements(annotationSelectors);
			});
		});

		this.addEventListener("stateChange", () => {
			this.positionElements(".entity")
		});
	}
}

customElements.define("wpn-text-view", WPNTextView);
