import OpenSeadragon from "openseadragon";

const facscontent: HTMLElement | null = document.getElementById("facscontent") ?? null;
if (!facscontent) {
	throw new Error("No facscontent element found");
}
const type = facscontent.getAttribute("wpn-type") ?? "";

// Dimension map based on witness type (width and height in cm)
const witnessTypeDimensions: Record<string, { width: number | null; height: number | null }> = {
	nonWitness: { width: null, height: null },
	witnessPrint: { width: 14.2, height: 21 },
	witnessTypescript: { width: 17.46, height: 23.4 },
	witnessTypescriptInsert: { width: 17.46, height: 23.4 },
	witnessTypescript2: { width: 18.63, height: 23.4 },
	witnessNote1: { width: 10.3, height: 18.1 },
	witnessPrint2: { width: 14.2, height: 21 },
	witnessTypescript3: { width: 18.63, height: 23.4 },
	witnessTypescript4: { width: 20.7, height: 25.9 }
};

const dimensions = witnessTypeDimensions[type];
if (dimensions) {
	if (dimensions.height !== null) {
		facscontent.style.height = `${dimensions.height}cm`;
	}
	if (dimensions.width !== null) {
		facscontent.style.width = `${dimensions.width}cm`;
	}
}
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