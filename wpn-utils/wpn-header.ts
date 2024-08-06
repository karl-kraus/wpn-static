class WPNHeader extends HTMLElement {
	resizeObserver = new ResizeObserver((entries) => {
		for (const entry of entries) {
			const mainElement = document.querySelector("main");
			const wpnDetailView = document.querySelector("wpn-detail-view");
			const footer = document.querySelector("footer");
			if (mainElement) {
				mainElement.style.marginTop = `${String(entry.target.clientHeight)}px`;
			}
			if (wpnDetailView) {
				(wpnDetailView as HTMLElement).style.top = `${String(entry.target.clientHeight)}px`;
				if (footer) {
					(wpnDetailView as HTMLElement).style.maxHeight =
						`calc(100% - ${String(entry.target.clientHeight + footer.clientHeight)}px`;
				}
			}
		}
	});

	connectedCallback() {
		this.resizeObserver.observe(this);
	}
	disconntedCallback() {
		this.resizeObserver.unobserve(this);
	}
}

customElements.define("wpn-header", WPNHeader);
