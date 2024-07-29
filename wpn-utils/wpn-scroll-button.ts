class WPNScrollButton extends HTMLButtonElement {
	
	
	
	connectedCallback() {
		const scrollDirection = this.getAttribute("scroll-direction") ?? "";
		const scrollContainer: HTMLElement | null = document.getElementById("scroll-container");
		this.onclick = () => {
			if (scrollContainer) {
				if (scrollDirection === "left") {
					scrollContainer.scrollTo(
						scrollContainer.scrollLeft -
							scrollContainer.children[0].clientWidth -
							parseInt(getComputedStyle(scrollContainer).columnGap),
						0,
					);
				}
				if (scrollDirection === "right") {
					scrollContainer.scrollTo(
						scrollContainer.scrollLeft +
							scrollContainer.clientWidth +
							parseInt(getComputedStyle(scrollContainer).columnGap),
						0,
					);
				}
			}
		};
	}
}

customElements.define("wpn-scroll-button", WPNScrollButton, { extends: "button" });
