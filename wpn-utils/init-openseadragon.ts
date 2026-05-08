import OpenSeadragon from "openseadragon";

const facscontent: HTMLElement | null = document.getElementById("facscontent") ?? null;
if (!facscontent) {
	throw new Error("No facscontent element found");
}
const type = facscontent.getAttribute("wpn-type") ?? "";
facscontent.style.height = type === "witnessPrint" ||
	type === "witnessTypescript2" ||
	type === "witnessNote1" ? "21cm" : "26cm";
facscontent.style.width = type === "witnessPrint" ||
	type === "witnessTypescript2" ||
	type === "witnessNote1" ? "14.2cm" : 
	type === "witnessTypescript2" || 
	type === "witnessTypescript3" ? "20.7cm" : "19.4cm";
const image = facscontent.getAttribute("wpn-data") ?? "";

const url = image.startsWith("https") ? image : `https://iiif.acdh.oeaw.ac.at/${image}.jp2/full/max/0/default.jpg`;

const imageUrl = {
	type: "image",
	url: url
}
OpenSeadragon({
	id: "facscontent",
	tileSources: imageUrl,
	prefixUrl: 'https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.1/images/',
});