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
    "connection-color-line", 
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

// const btn = document.getElementById("btn_more_text_layers");

// btn?.addEventListener("click", () => {

//     const dropdown = document.getElementById("list_more_layers_btn");
//     if (dropdown) {
//         dropdown.classList.toggle("d-none");
//         dropdown.ariaExpanded === "true" ? dropdown.ariaExpanded = "false" : dropdown.ariaExpanded = "true";
//     }

// });

// const list_layers_line = document.querySelectorAll<HTMLElement>(".list_more_text_layers_line");

// list_layers_line.forEach((li) => {

//     const correspList = li.dataset.link?.split(" ");

//     correspList?.forEach((cor) => {
//         const cor_class = cor.replace("#", "");
//         const cor_target = document.querySelectorAll(`.${cor_class} canvas`);
//         const targetMarker = document.querySelectorAll<HTMLElement>(`[data-link~="${cor_class}"]`);
//         [...cor_target].forEach(target => {
//             target.addEventListener("mouseover", (e) => {
//                 e.preventDefault();
//                 target.classList.toggle("connection-color");
//                 targetMarker.forEach((marker) => {
//                     marker.classList.toggle("connection-color");
//                 });
//             });
//         });
//         [...cor_target].forEach(target => {
//             target.addEventListener("mouseout", (e) => {
//                 e.preventDefault();
//                 target.classList.toggle("connection-color");
//                 targetMarker.forEach((marker) => {
//                     marker.classList.toggle("connection-color");
//                 });
//             });
//         });
//     });

//     li.addEventListener("mouseover", (e) => {

//         e.preventDefault();

//         li.classList.toggle("connection-color");

//         const corresp = li.dataset.link?.split(" ");
//         const unique: Array<string> = [];
//         corresp?.forEach((cor) => {

//             const cor_class = cor.replace("#", "");

//             if (!unique.includes(cor_class)) {

                
//                 const canvas = document.querySelectorAll<HTMLCanvasElement>(`.${cor_class} canvas`);
                
//                 [...canvas].map((item) => {
//                     const double = item.classList.contains("double") ? true : false;
//                     const width = item.width;
//                     const height = item.height;
//                     const x1 = item.dataset.x1 ? parseInt(item.dataset.x1) : 0;
//                     const x2 = item.dataset.x2 ? parseInt(item.dataset.x2) : 0;
//                     const target = item.dataset.target;
//                     const span = item.dataset.span;
//                     const ctx = item.getContext("2d");

//                     if (target) {
//                         const targetElement = document.getElementById(target);
//                         targetElement?.classList.add(...["border", "border-danger-subtle", "border-2", "border-dotted"]);
//                     }

//                     if (span) {
//                         const spanElement = document.getElementById(span);
//                         spanElement?.classList.add(...["border", "border-danger-subtle", "border-2", "border-dotted"]);
//                     }

//                     if (ctx) {
//                         ctx.clearRect(0, 0, width, height);
//                         drawstroke(ctx, x1, 0, x2, height, 3, '#ff8181', double);
//                     }
//                 });

//                 unique.push(cor_class);
//             }
            
//         });

//     });

//     li.addEventListener("mouseout", (e) => {

//         e.preventDefault();

//         li.classList.toggle("connection-color");

//         const corresp = li.dataset.link?.split(" ");
//         const unique: Array<string> = [];
//         corresp?.forEach((cor) => {

//             const cor_class = cor.replace("#", "");

//             if (!unique.includes(cor_class)) {
//                 const canvas = document.querySelectorAll<HTMLCanvasElement>(`.${cor_class} canvas`);
                
//                 [...canvas].map((item) => {
//                     const double = item.classList.contains("double") ? true : false;
//                     const width = item.width;
//                     const height = item.height;
//                     const x1 = item.dataset.x1 ? parseInt(item.dataset.x1) : 0;
//                     const x2 = item.dataset.x2 ? parseInt(item.dataset.x2) : 0;
//                     const target = item.dataset.target;
//                     const span = item.dataset.span;
//                     const ctx = item.getContext("2d");

//                     if (target) {
//                         const targetElement = document.getElementById(target);
//                         targetElement?.classList.remove("connection-color");
//                     }

//                     if (span) {
//                         const spanElement = document.getElementById(span);
//                         spanElement?.classList.remove("connection-color");
//                     }

//                     if (ctx) {
//                         ctx.clearRect(0, 0, width, height);
//                         drawstroke(ctx, x1, 0, x2, height, 1, '#ff8181', double);
//                     }
//                 });

//                 unique.push(cor_class);
//             }

//         });

//     });

// });

// function drawstroke(
//     ctx: CanvasRenderingContext2D,
//     startX: number,
//     startY: number,
//     endX: number,
//     endY: number,
//     lineWidth: number,
//     color: string,
//     double: boolean) {

//     ctx.beginPath();
//     ctx.moveTo(startX, startY);
//     ctx.lineTo(endX, endY);
//     ctx.lineWidth = lineWidth;
//     ctx.strokeStyle = color;
//     ctx.stroke();

//     if (double) {
//         ctx.beginPath();
//         ctx.moveTo(startX + 5, startY);
//         ctx.lineTo(endX + 5, endY);
//         ctx.lineWidth = lineWidth;
//         ctx.strokeStyle = color;
//         ctx.stroke();
//     }

// }
