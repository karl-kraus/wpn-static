import OpenSeadragon from "openseadragon";

const facscontent = document.getElementById("facscontent") as HTMLElement;
facscontent.style.height = window.innerHeight - 190 + "px";
facscontent.style.width = window.innerWidth * 0.4 + "px";
const image = facscontent.getAttribute("wpn-data") ?? "";
const imageUrl = {
	type: "image",
	url: `https://iiif.acdh.oeaw.ac.at/${image}.jp2/full/max/0/default.jpg`
}
OpenSeadragon({
	id: "facscontent",
	tileSources: imageUrl,
	prefixUrl: 'https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.1/images/',
});