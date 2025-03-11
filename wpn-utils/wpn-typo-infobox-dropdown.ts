// ######################################################
// Text Block 1 in xsl/partials/typo-info-3rd-column.xsl
// ######################################################
const paragraph_block_1 = document.getElementById("paragraph-block-1");

paragraph_block_1?.addEventListener("mouseover", (e) => {

    e.preventDefault();

    paragraph_block_1.classList.toggle("bg-danger-subtle");

    const corresp = paragraph_block_1.dataset.link?.split(" ");

    corresp?.forEach((cor) => {
        const cor_class = cor.replace("#", "");
        const target = document.querySelectorAll<HTMLElement>(`.fw.${cor_class}`);
        [...target].map(target => target.classList.toggle("bg-danger-subtle"));
    });

});

paragraph_block_1?.addEventListener("mouseout", (e) => {

    e.preventDefault();

    paragraph_block_1.classList.toggle("bg-danger-subtle");

    const corresp = paragraph_block_1.dataset.link?.split(" ");

    corresp?.forEach((cor) => {
        const cor_class = cor.replace("#", "");
        const target = document.querySelectorAll<HTMLElement>(`.fw.${cor_class}`);
        [...target].map(target => target.classList.toggle("bg-danger-subtle"));
    });

});

// ######################################################
// Text Block 4 in xsl/partials/typo-info-3rd-column.xsl
// ######################################################
const btn = document.getElementById("btn_more_text_layers");

btn?.addEventListener("click", () => {

    const dropdown = document.getElementById("list_more_layers_btn");
    if (dropdown) {
        dropdown.classList.toggle("d-none");
        dropdown.ariaExpanded === "true" ? dropdown.ariaExpanded = "false" : dropdown.ariaExpanded = "true";
    }

});

const list_layers = document.querySelectorAll<HTMLElement>(".list_more_text_layers");

list_layers.forEach((li) => {

    li.addEventListener("mouseover", (e) => {

        e.preventDefault();

        li.classList.toggle("bg-danger-subtle");

        const corresp = li.dataset.link?.split(" ");

        corresp?.forEach((cor) => {
            const cor_class = cor.replace("#", "");
            const target = document.querySelectorAll<HTMLElement>(`.${cor_class}`);
            [...target].map(target => target.classList.toggle("bg-danger-subtle"));
        });

    });

    li.addEventListener("mouseout", (e) => {

        e.preventDefault();

        li.classList.toggle("bg-danger-subtle");

        const corresp = li.dataset.link?.split(" ");

        corresp?.forEach((cor) => {
            const cor_class = cor.replace("#", "");
            const target = document.querySelectorAll<HTMLElement>(`.${cor_class}`);
            [...target].map(target => target.classList.toggle("bg-danger-subtle"));
        });

    });

});

const list_layers_line = document.querySelectorAll<HTMLElement>(".list_more_text_layers_line");

list_layers_line.forEach((li) => {

    li.addEventListener("mouseover", (e) => {

        e.preventDefault();

        li.classList.toggle("bg-danger-subtle");

        const corresp = li.dataset.link?.split(" ");
        const unique: Array<string> = [];
        corresp?.forEach((cor) => {

            const cor_class = cor.replace("#", "");

            if (!unique.includes(cor_class)) {

                
                const canvas = document.querySelectorAll<HTMLCanvasElement>(`.${cor_class} canvas`);
                
                [...canvas].map((item) => {
                    const double = item.classList.contains("double") ? true : false;
                    const width = item.width;
                    const height = item.height;
                    const x1 = item.dataset.x1 ? parseInt(item.dataset.x1) : 0;
                    const x2 = item.dataset.x2 ? parseInt(item.dataset.x2) : 0;
                    const target = item.dataset.target;
                    const span = item.dataset.span;
                    const ctx = item.getContext("2d");

                    if (target) {
                        const targetElement = document.getElementById(target);
                        targetElement?.classList.add(...["border", "border-danger-subtle", "border-2", "border-dotted"]);
                    }

                    if (span) {
                        const spanElement = document.getElementById(span);
                        spanElement?.classList.add(...["border", "border-danger-subtle", "border-2", "border-dotted"]);
                    }

                    if (ctx) {
                        ctx.clearRect(0, 0, width, height);
                        drawstroke(ctx, x1, 0, x2, height, 3, '#ff8181', double);
                    }
                });

                unique.push(cor_class);
            }
            
        });

    });

    li.addEventListener("mouseout", (e) => {

        e.preventDefault();

        li.classList.toggle("bg-danger-subtle");

        const corresp = li.dataset.link?.split(" ");
        const unique: Array<string> = [];
        corresp?.forEach((cor) => {

            const cor_class = cor.replace("#", "");

            if (!unique.includes(cor_class)) {
                const canvas = document.querySelectorAll<HTMLCanvasElement>(`.${cor_class} canvas`);
                
                [...canvas].map((item) => {
                    const double = item.classList.contains("double") ? true : false;
                    const width = item.width;
                    const height = item.height;
                    const x1 = item.dataset.x1 ? parseInt(item.dataset.x1) : 0;
                    const x2 = item.dataset.x2 ? parseInt(item.dataset.x2) : 0;
                    const target = item.dataset.target;
                    const span = item.dataset.span;
                    const ctx = item.getContext("2d");

                    if (target) {
                        const targetElement = document.getElementById(target);
                        targetElement?.classList.remove(...["border", "border-danger-subtle", "border-2", "border-dotted"]);
                    }

                    if (span) {
                        const spanElement = document.getElementById(span);
                        spanElement?.classList.remove(...["border", "border-danger-subtle", "border-2", "border-dotted"]);
                    }

                    if (ctx) {
                        ctx.clearRect(0, 0, width, height);
                        drawstroke(ctx, x1, 0, x2, height, 1, '#ff8181', double);
                    }
                });

                unique.push(cor_class);
            }

        });

    });

});

function drawstroke(
    ctx: CanvasRenderingContext2D,
    startX: number,
    startY: number,
    endX: number,
    endY: number,
    lineWidth: number,
    color: string,
    double: boolean) {

    ctx.beginPath();
    ctx.moveTo(startX, startY);
    ctx.lineTo(endX, endY);
    ctx.lineWidth = lineWidth;
    ctx.strokeStyle = color;
    ctx.stroke();

    if (double) {
        ctx.beginPath();
        ctx.moveTo(startX + 5, startY);
        ctx.lineTo(endX + 5, endY);
        ctx.lineWidth = lineWidth;
        ctx.strokeStyle = color;
        ctx.stroke();
    }

}

// ######################################################
// Text Block 5 in xsl/partials/typo-info-3rd-column.xsl
// ######################################################
const tpq = document.querySelectorAll<HTMLElement>(".tpq");

tpq.forEach((p) => {

    p.addEventListener("mouseover", (e) => {

        e.preventDefault();

        p.classList.toggle("bg-danger-subtle");

        const corresp = p.dataset.link?.split(" ");

        corresp?.forEach((cor) => {

            const cor_class = cor.replace("#", "");

            const target = document.getElementById(cor_class);
            target?.classList.toggle("bg-danger-subtle");

            target?.querySelectorAll(".d-block").forEach((el) => {
                el.classList.toggle("bg-danger-subtle");
            });

        });

    });

    p.addEventListener("mouseout", (e) => {

        e.preventDefault();

        p.classList.toggle("bg-danger-subtle");

        const corresp = p.dataset.link?.split(" ");

        corresp?.forEach((cor) => {

            const cor_class = cor.replace("#", "");

            const target = document.getElementById(cor_class);
            target?.classList.toggle("bg-danger-subtle");

            target?.querySelectorAll(".d-block").forEach((el) => {
                el.classList.toggle("bg-danger-subtle");
            });

        });

    });

});

// ######################################################
// Text Block 6 in xsl/partials/typo-info-3rd-column.xsl
// ######################################################
const delQP = document.querySelectorAll<HTMLElement>(".delQP");

delQP.forEach((p) => {

    p.addEventListener("mouseover", (e) => {
        e.preventDefault();

        p.classList.toggle("bg-danger-subtle");

        const corresp = p.dataset.link?.split(" ");

        corresp?.forEach((cor) => {
            const cor_class = cor.replace("#", "");
            const target = document.getElementById(cor_class);
            target?.classList.toggle("bg-danger-subtle");
        });
    });

    p.addEventListener("mouseout", (e) => {
        e.preventDefault();

        p.classList.toggle("bg-danger-subtle");

        const corresp = p.dataset.link?.split(" ");

        corresp?.forEach((cor) => {
            const cor_class = cor.replace("#", "");
            const target = document.getElementById(cor_class);
            target?.classList.toggle("bg-danger-subtle");
        });
    });

});

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