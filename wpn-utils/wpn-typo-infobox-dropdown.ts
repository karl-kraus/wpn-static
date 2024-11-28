const btn = document.getElementById("btn_more_text_layers");

btn?.addEventListener("click", () => {

    const dropdown = document.getElementById("list_more_text_layers");
    if (dropdown) {
        dropdown.classList.toggle("d-none");
        dropdown.ariaExpanded === "true" ? dropdown.ariaExpanded = "false" : dropdown.ariaExpanded = "true";
    }

});

const list_layers = document.querySelectorAll<HTMLElement>("#list_more_text_layers li");

list_layers.forEach((li) => {

    li.addEventListener("click", (e) => {

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

const tpq = document.querySelectorAll<HTMLElement>(".tpq");

tpq.forEach((p) => {

    p.addEventListener("click", (e) => {

        e.preventDefault();

        p.classList.toggle("bg-danger-subtle");

        const corresp = p.dataset.link?.split(" ");

        corresp?.forEach((cor) => {
            const cor_class = cor.replace("#", "");
            const target = document.getElementById(cor_class);
            target?.classList.toggle("bg-danger-subtle");   
            target?.children[0].classList.toggle("bg-danger-subtle");            
        });

    });

});

const delQP = document.querySelectorAll<HTMLElement>(".delQP");

delQP.forEach((p) => {

    p.addEventListener("click", (e) => {
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