class WPNHeader extends HTMLElement {
	resizeObserver = new ResizeObserver((entries) => {
		for (const entry of entries) {
			const isAnnotationView = Boolean(document.querySelector("wpn-text-view"));
			const isTimelineView = Boolean(document.querySelector("wpn-time-line"));
			const mainElement = isAnnotationView
				? document.querySelector("wpn-text-view")
				: isTimelineView ? document.querySelector(".wrapper") : document.querySelector("main");
			const wpnDetailView = document.querySelector("wpn-detail-view");
			const footer = document.querySelector("footer");
			if (mainElement) {
				(mainElement as HTMLElement).style.marginTop = `${String(entry.target.clientHeight)}px`;
			}
			if (wpnDetailView && !isAnnotationView && !isTimelineView) {
				(wpnDetailView as HTMLElement).style.top = `${String(entry.target.clientHeight)}px`;
				if (footer) {
					(wpnDetailView as HTMLElement).style.maxHeight =
						`calc(100vh - ${String(entry.target.clientHeight + footer.clientHeight)}px`;
				}
			}
			if (isAnnotationView) {
				const stickyElement = document.querySelector(".position-sticky");
				if (stickyElement) {
					(stickyElement as HTMLElement).style.top = `${String(entry.target.clientHeight)}px`;
					if (footer) {
						(stickyElement as HTMLElement).style.height = `calc(100vh - ${String(entry.target.clientHeight + footer.clientHeight)}px`;
					}
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
