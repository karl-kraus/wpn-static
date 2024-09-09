import { getHighlightedParts } from "instantsearch.js/es/lib/utils";
import TypesenseInstantSearchAdapter from "typesense-instantsearch-adapter";

const project_collection_name = "walpurgisnacht";
const typesenseInstantsearchAdapter: TypesenseInstantSearchAdapter =
	new TypesenseInstantSearchAdapter({
		server: {
			apiKey: "xyz", // Be sure to use an API key that only allows searches, in production
			nodes: [
				{
					host: "localhost",
					port: 8108,
					protocol: "http",
				},
			],
		},

		additionalSearchParameters: {
			query_by: "full_text,title",
			highlight_affix_num_tokens: 5,
			sort_by: "order:asc",
		},
	});

const searchClient = typesenseInstantsearchAdapter.searchClient;

const search = instantsearch({
	searchClient,
	indexName: project_collection_name,
	routing: true,
});

search.addWidgets([
	instantsearch.widgets.searchBox({
		container: "#searchbox",
		autofocus: true,
		showReset: false,
		cssClasses: {
			form: "d-flex flex-wrap gap-2",
			input:
				"col-md-12 rounded-0 w-75 form-control border-top-0 border-start-0 border-end-0 border-bottom",
			submit: "btn btn-outline-black-grey",
		},
		templates: {
			submit: '"Suche"',
		},
	}),

	instantsearch.widgets.hits({
		container: "#hits",
		cssClasses: {
			item: "w-20 border-bottom border-light-grey m-2 d-flex flex-column hover-shadow",
			list: "p-0",
		},
		templates: {
			empty: "No results for <q>{{ query }}</q>",
			item(hit, { html, components }) {
				const snippets = snippetsFromHighlightedContent(hit.id, hit._highlightResult.full_text.value);
				console.log(snippets);

				return `
              <p><a class="link-black-grey text-decoration-none" href="${hit.id}">${hit.title}</a></p>
              ${snippets}
          `;
			},
		},
	}),

	instantsearch.widgets.stats({
		container: "#stats-container",
		templates: {
			text(data, { html }) {
				let hitsTerm = data.hasManyResults ? "Absätzen" : "Absatz";
				let message = "";
				if (data.query === "*") {
					message = `${data.nbHits} Absätze gefunden`;
				} else {
					message = data.hasNoResults
						? "Suchbegriff nicht gefunden"
						: `Suchbegriff in ${data.nbHits} ${hitsTerm} gefunden`;
				}
				return html`<span>${message}</span>`;
			},
		},
	}),

	instantsearch.widgets.pagination({
		container: "#pagination",
		cssClasses: {
			list: ["d-flex", "list-unstyled", "m-0"],
			item: ["p-2"],
			link: ["link-black-grey", "text-decoration-none"],
			selectedItem: ["fw-bold"],
		},
	}),

	instantsearch.widgets.configure({
		hitsPerPage: 25,
		attributesToSnippet: ["full_text"],
	}),
]);

const snippetsFromHighlightedContent = (hitid, highlightedContent) => {
	const snippetArray = getHighlightedParts(highlightedContent);
	return snippetArray
		.map((elm, idx) => {
			if (elm.isHighlighted) {
				let snippet = "<p>&#x2026;";
				const segmenter = new Intl.Segmenter("de", { granularity: "word" });
				snippet += Array.from(segmenter.segment(snippetArray[idx - 1]?.value))
					.map((seg) => seg.segment)
					.slice(1)
					.slice(-10)
					.join("");
				snippet += `<a href="${hitid}?mark=${elm.value}" class="link-primary text-decoration-none ff-ubuntu">${elm.value}</a>`;
				snippet += Array.from(segmenter.segment(snippetArray[idx + 1]?.value))
					.map((seg) => seg.segment)
					.slice(0, 10)
					.join("");
				snippet += "&#x2026;</p>";
				return snippet;
			}
		})
		.filter((item) => item)
		.join("");
};

search.start();
