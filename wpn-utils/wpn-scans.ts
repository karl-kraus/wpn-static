import type { Rect, Viewer } from "openseadragon";

class WPNScans extends HTMLElement {
	get facs(): Array<TileSourceData> {
		return JSON.parse(this.getAttribute("facs") ?? "") as Array<TileSourceData>;
	}

	connectedCallback() {
		const parentDetails = this.parentElement as HTMLDetailsElement;
		let viewer: Viewer;
		parentDetails.addEventListener("toggle", () => {
			if (parentDetails.open) {
				viewer = OpenSeadragon({
					id: this.id,
					preserveViewport: true,
					defaultZoomLevel: 0,
					minPixelRatio: 0,
					tileSources: this.facs.map((f) => f.url),
					prefixUrl: "https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.1/images/",
					sequenceMode: true,
					showZoomControl: true,
					constrainDuringPan: true,
				});

				const rects: Array<Rect> = [];
				if (this.facs.length === 1) {
					const tileSourceData: TileSourceData = this.facs[0];
					tileSourceData.overlays.forEach((overlay, idx) => {
						const { x, y, width, height }: RectProperties = overlay;
						const elt = document.createElement("div");
						elt.className = "osd_overlay";
						elt.id = `overlay_${String(idx)}`;
						const rect = new OpenSeadragon.Rect(x, y, width, height);

						viewer.addOverlay({
							element: elt,
							location: rect,
						});
						rects.push(rect);
					});
				}

				viewer.addHandler("open", () => {
					if (rects.length) {
						let overlayRect = rects[0];
						if (rects.length > 1) {
							for (let idx = 1; idx < rects.length; idx++)
								overlayRect = overlayRect.union(rects[idx]);
						}
						viewer.viewport.fitBounds(overlayRect, true);
					}
				});

				viewer.addHandler("page", () => {
					const currentPage = viewer.currentPage();
				});
			} else {
				viewer.destroy();
			}
		});
	}
}

interface TileSourceData {
	url: string;
	overlays: Array<RectProperties>;
}

interface RectProperties {
	x: number;
	y: number;
	width: number;
	height: number;
}

customElements.define("wpn-scans", WPNScans);
