class WPNToggleTextButton extends HTMLElement {
	toggleClass = "wpn-expand";
	toggleText = "Expand Text";
	
	getToggleTarget(targetElementId: string): HTMLElement | null {
		const targetElement: HTMLElement | null = document.getElementById(targetElementId);
		return targetElement;
	}

	connectedCallback() {
		const text = this.innerHTML;
		this.onclick = (e) => {
			e.preventDefault();
			const targetElementId: string | null = this.getAttribute("target-element") ?? "";
			const targetElement: HTMLElement | null = this.getToggleTarget(targetElementId);
			if (targetElement) {
				targetElement.classList.toggle(this.toggleClass);
				if (targetElement.classList.contains(this.toggleClass)) {
					this.innerText = this.getAttribute("toggle-text") ?? this.toggleText;
				} else {
					this.innerText = text;
					if (targetElement.getBoundingClientRect().top < document.getElementsByTagName("main")[0].offsetTop) {
						window.scrollTo({top:targetElement.offsetTop - document.getElementsByTagName("main")[0].offsetTop})
					}
				}
			}
		};
	}
}
customElements.define("wpn-toggle-text-button", WPNToggleTextButton);
