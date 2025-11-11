const visualize_connections = (
    color: string,
    target_color: string,
    class_selector: string[],
    selector: string = "class",
    query_prefix: string = "", 
    prefix_pos: number | false = false,
    bidirectional: boolean = true
) => {

    class_selector.forEach((className, idx) => {

        let prefix = "";

        if (prefix_pos !== false && typeof prefix_pos === "number" && idx === prefix_pos) {
            prefix = query_prefix;
        }

        const elements = document.querySelectorAll<HTMLElement>(`.${className}`);
        elements?.forEach((el) => {

            const corresp = el.dataset.link?.split(" ");
            el.addEventListener("mouseover", (e) => {
                
                e.preventDefault();
                el.classList.add(color);
                corresp?.forEach((cor) => {
                    
                    if (selector === "class") {

                        const target = document.querySelectorAll<HTMLElement>(`${prefix}.${cor}`);
                        [...target].map(target => target.classList.add(target_color));

                    } else if (selector === "id") {

                        const target = document.getElementById(cor);
                        target?.classList.add(target_color);

                    }

                });

            });

            el.addEventListener("mouseout", (e) => {
                
                e.preventDefault();
                el.classList.remove(color);

                corresp?.forEach((cor) => {

                    if (selector === "class") {

                        const target = document.querySelectorAll<HTMLElement>(`${prefix}.${cor}`);
                        [...target].map(target => target.classList.remove(target_color));

                    } else if (selector === "id") {

                        const target = document.getElementById(cor);
                        target?.classList.remove(target_color);

                    }

                });

            });

            if (bidirectional) {
                corresp?.forEach((cor) => {

                    if (selector === "class") {
                        const target = document.querySelectorAll<HTMLElement>(`${prefix}.${cor}`);
                        // const targetMarker = document.querySelectorAll<HTMLElement>(`[data-link~="${cor_class}"]`);

                        [...target].forEach(target => {

                            target.addEventListener("mouseover", (e) => {

                                e.preventDefault();
                                target.classList.add(target_color);
                                el.classList.add(color);

                            });

                            target.addEventListener("mouseout", (e) => {

                                e.preventDefault();
                                target.classList.remove(target_color);
                                el.classList.remove(color);

                            });

                        });

                    } else if (selector === "id") {

                        const target = document.getElementById(cor);
                        target?.addEventListener("mouseover", (e) => {

                            e.preventDefault();
                            target.classList.add(target_color);
                            el.classList.add(color);

                        });

                        target?.addEventListener("mouseout", (e) => {

                            e.preventDefault();
                            target.classList.remove(target_color);
                            el.classList.remove(color);

                        });

                    }

                });
            };
        });
    });
};

// ######################################################
// Text Block 1 in xsl/partials/typo-info-3rd-column.xsl
// ######################################################
const paragraph_block = "paragraph-block";
// ######################################################
// Text Block 4 in xsl/partials/typo-info-3rd-column.xsl
// ######################################################
const list_more_text_layers = "list_more_text_layers";
const list_more_text_layers_line = "list_more_text_layers_line";
// ######################################################
// Text Block 5 in xsl/partials/typo-info-3rd-column.xsl
// ######################################################
const tpq = "tpq";
// ######################################################
// Text Block 6 in xsl/partials/typo-info-3rd-column.xsl
// ######################################################
const delQP = "delQP";

visualize_connections(
    "connection-color", 
    "connection-color", 
    [paragraph_block, list_more_text_layers],
    "class",
    ".fw",
    0,
    true
);
visualize_connections(
    "connection-color",
    "connection-color", 
    [tpq, delQP],
    "id",
    "",
    false,
    false
);
visualize_connections(
    "connection-color",
    "active",
    [list_more_text_layers_line],
    "id",
    "",
    false,
    false
);

// ######################################################
// Short Info Boxes Toggle
// ######################################################
const short_info = document.querySelectorAll<HTMLElement>(".bg-position-short-info");
short_info.forEach((el) => {

    el.classList.toggle("d-none");

    // el.addEventListener("click", (e) => {
    //     e.preventDefault();

    //     const box_id = el.querySelector("a")?.href;
    //     const box = document.getElementById(box_id?.replace('#', 'details_') ?? "");
    //     box?.classList.toggle("d-none");
    // });

});
