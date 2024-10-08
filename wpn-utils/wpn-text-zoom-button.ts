class WPNTextZoomButton extends HTMLElement {
	
	
	
	connectedCallback() {
		const zoomDirection = this.getAttribute("zoom-direction") ?? "";
		const textViewElement: HTMLElement | null = document.querySelector("#textcontent") ?? document.querySelector("#textcontent-pb") ?? null;
		this.onclick = () => {
			
			if (textViewElement) {
				if (zoomDirection === "in") {
					const fontSize = parseInt(getComputedStyle(textViewElement).getPropertyValue("font-size"));
					textViewElement.style.fontSize = `${String(fontSize + 1)}px`;
				}
				if (zoomDirection === "out") {
					const fontSize = parseInt(getComputedStyle(textViewElement).getPropertyValue("font-size"));
					textViewElement.style.fontSize = `${String(fontSize - 1)}px`;
				}
			}
		};
	}
}

customElements.define("wpn-text-zoom-button", WPNTextZoomButton);
