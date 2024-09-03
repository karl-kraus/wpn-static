import { LoadEditor } from "de-micro-editor";

const le = new LoadEditor({
  aot: {
    title: "Text Annotations",
    variants: [
      {
        opt: "quts",
        color: "annot_quote",
        title: "Intertexte",
        html_class: "quotes",
        css_class: "quts",
        chg_citation: "citation-url",
        hide: {
          hidden: false,
          class: "quotes .entity",
        },
        features: {
          all: false,
          class: "features-1",
        },
      },
      {
        opt: "prs",
        color: "annot_person",
        title: "Personen",
        html_class: "persons",
        css_class: "prs",
        chg_citation: "citation-url",
        hide: {
          hidden: false,
          class: "persons .entity",
        },
        features: {
          all: false,
          class: "features-2",
        },
      },
      {
        opt: "pbs",
        title: "Seitenumbrüche",
        html_class: "pagebreaks",
        css_class: "pbs",
        chg_citation: "citation-url",
        hide: {
          hidden: true,
          class:"pagebreaks",
        },
        features: {
          all: false,
          class: "features-3",
        },
      },
      {
        opt: "cmts",
        color: "annot_comment",
        title: "Stellenkommentare",
        html_class: "comments",
        css_class: "cmts",
        chg_citation: "citation-url",
        hide: {
          hidden: false,
          class:"comments",
        },
        features: {
          all: false,
          class: "features-4",
        },
      }
    ],
},
up: true
})
/** set aot slider status on page load **/
le.upc.textFeatures()