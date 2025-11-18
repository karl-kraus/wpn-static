// Description: This script is used to connect elements in 
// left and right margin with their anchor in the text.

document.querySelector<HTMLElement>("#infocontent-pb")?.addEventListener("mouseover", (event) => {

    const color = "connection-color";
    const color_line = "connection-color-line";
    const target = event.target as HTMLElement;
    const dataLink = target.dataset.link;
    const dataLinkOne = target.dataset.linkone;

    if (!dataLink) {
        document.querySelectorAll<HTMLElement>(`.${color}`).forEach((el) => {

            el.classList.remove(color);

        });
        document.querySelectorAll<HTMLElement>(`.${color_line}.active`).forEach((el) => {

            el.classList.remove("active");

        });
    };

    const dataLinkList = dataLink ? dataLink.split(" ") : [];

    dataLinkList.forEach((link) => {

        // highlight anchor
        const anchorElements = document.querySelectorAll<HTMLElement>(`[data-hand~="${link}"]`);

        if(anchorElements.length > 0) {

            target.classList.remove(color);
            target.classList.add(color);

            anchorElements.forEach((el) => {

                el.classList.remove(color);
                el.classList.add(color);
            
            });

        }

        // highlight linked elements
        const linkedElements = document.querySelectorAll<HTMLElement>(`[data-anchor~="${link}"]`);

        if(linkedElements.length > 0) {

            target.classList.remove("active");
            target.classList.add("active");

            linkedElements.forEach((el) => {

                el.classList.remove("active");
                el.classList.add("active");
            
            });
            
        }

    });

    const dataLinkOneList = dataLinkOne ? dataLinkOne.split(" ") : [];
    
    dataLinkOneList.forEach((link) => {
        // highlight linked elements
        const linkedElements = document.querySelectorAll<HTMLElement>(`[data-anchor~="${link}"]`);
        
        if(linkedElements.length > 0) {

            target.classList.remove(color);
            target.classList.add(color);
            
            linkedElements.forEach((el) => {

                el.classList.remove(color);
                el.classList.add(color);
                
            });
        }
    });

});

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
