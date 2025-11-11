// Description: This script is used to connect elements in 
// left and right margin with their anchor in the text.

document.querySelector<HTMLElement>("#infocontent-pb")?.addEventListener("mouseover", (event) => {

    const color = "connection-color";
    
    const target = event.target as HTMLElement;

    const anchorData = target.dataset.anchor;

    if (!anchorData) {
        document.querySelectorAll<HTMLElement>(`.${color}`).forEach((el) => {

            el.classList.remove(color);

        });
    };

    const anchorDataList = anchorData ? anchorData.split(" ") : [];

    anchorDataList.forEach((data) => {

        // highlight anchor
        const anchorElements = document.querySelectorAll<HTMLElement>(`[data-anchor~="${data}"]`);

        if(anchorElements.length > 1) {

            target.classList.add(color);

            anchorElements.forEach((el) => {

                el.classList.add(color);
            
            });

        }

    });

    const dataLink = target.dataset.link;

    if (!dataLink) {
        document.querySelectorAll<HTMLElement>(".active").forEach((el) => {

            el.classList.remove("active");

        });
    };

    const dataLinkList = dataLink ? dataLink.split(" ") : [];

    dataLinkList.forEach((link) => {

        // highlight linked elements
        const linkedElements = document.querySelectorAll<HTMLElement>(`[data-anchor~="${link}"]`);

        if(linkedElements.length > 0) {

            target.classList.add("active");

            linkedElements.forEach((el) => {

                el.classList.add("active");
            
            });
            
        }
    });

    const dataLinkOne = target.dataset.linkone;
    const dataLinkOneList = dataLinkOne ? dataLinkOne.split(" ") : [];
    
    dataLinkOneList.forEach((link) => {
        // highlight linked elements
        const linkedElements = document.querySelectorAll<HTMLElement>(`[data-anchor~="${link}"]`);
        
        if(linkedElements.length > 0) {
            target.classList.add(color);
            
            linkedElements.forEach((el) => {

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
