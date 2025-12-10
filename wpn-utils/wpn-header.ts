class WPNHeader extends HTMLElement {
	private _scrollHandler?: () => void;

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
		const navOffset = document.querySelector("#primary_nav")?.clientHeight;
		document.documentElement.style.setProperty('--nav-offset', `${navOffset}px`);
		this.resizeObserver.observe(this);
		/* only on landing page */
		if (document.querySelector("body#home")) {
			this._scrollHandler = this.resizeHeader();
			window.addEventListener("scroll", this._scrollHandler);
		}
	}
	disconntedCallback() {
		this.resizeObserver.unobserve(this);
		  if (this._scrollHandler) {
        window.removeEventListener("scroll", this._scrollHandler);
      }
	}
	resizeHeader = () => {
			const logo = document.querySelector("#logo");
			const logoWidth = Number(logo?.getAttribute("width"));
			const navOffset = document.querySelector("#primary_nav")?.clientHeight;
			return () => {
				logo?.setAttribute("width", String(window.scrollY > 0 ? logoWidth / 2 : logoWidth));
				document.documentElement.style.setProperty('--nav-offset', String(window.scrollY > 0 ? `${document.querySelector("#primary_nav")?.clientHeight}px` : `${navOffset}px`));	
			}
		}
  }

customElements.define("wpn-header", WPNHeader);
