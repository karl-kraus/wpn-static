import { createHash } from "node:crypto";
import { readFileSync, renameSync, writeFileSync } from "node:fs";
import { basename,resolve } from "node:path";

import { glob } from "glob";
import { defineConfig } from "vite";


type FileMapping = Record<string, {file: string}>;

export default defineConfig({
	build: {
		minify: "terser",
		lib: {
			// https://gist.github.com/jasenmichael/58dd3a4f8e7ec1d003e88907bba392d7
			entry: glob.sync(resolve(__dirname, "wpn-utils/*.ts")),
			formats: ["es"],
		},
		outDir: resolve(__dirname, "html/js/wpn_utils"),
		rollupOptions: {
			output: {
				entryFileNames: "[name].[hash].js",
			},
		},
		manifest: "manifest.json",
	},
	plugins: [
		{
			name: "hashCSS",
			closeBundle() {
				const CSSManifestFile = "css_manifest.json";
				const CSSFiles = glob.sync(resolve(__dirname, "html/css/*.css"), { withFileTypes: true });
				writeFileSync(CSSManifestFile, '');
				const CSSMetaData: FileMapping = {};
				for (const CSSFile of CSSFiles) {
					const data = readFileSync(CSSFile.fullpath());
					const hash = createHash("sha256").update(data).digest("hex").substring(0, 8);
					const fileName = [basename(CSSFile.name, ".css"), hash, "css"].join(".");
					CSSMetaData[basename(CSSFile.name, ".css")] = {file: fileName}
					renameSync(CSSFile.fullpath(), resolve(__dirname, "html/css/", fileName));
				}
				writeFileSync(CSSManifestFile, JSON.stringify(CSSMetaData), { flag: 'a+' })
			},
		},
	],
});
