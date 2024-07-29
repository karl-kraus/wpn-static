class WPNToggleTextButton extends HTMLAnchorElement {
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
			const target_element: HTMLElement | null = this.getToggleTarget(targetElementId);
			if (target_element) {
				target_element.classList.toggle(this.toggleClass);
				if (target_element.classList.contains(this.toggleClass)) {
					this.innerText = this.getAttribute("toggle-text") ?? this.toggleText;
				} else {
					this.innerText = text;
				}
			}
		};
	}
}
customElements.define("wpn-toggle-text-button", WPNToggleTextButton, { extends: "a" });
