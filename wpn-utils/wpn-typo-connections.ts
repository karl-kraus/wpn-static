// Description: This script is used to connect elements in 
// left and right margin with their anchor in the text.
const myurl = new URL(window.location.href);
const searchParams = new URLSearchParams(myurl.search);
const content = document.querySelector<HTMLElement>("#print-page");
const info = document.querySelector<HTMLElement>("#infocontent-pb");

// Default mode: explore for Desktop
// Default mode: inspect for Mobile

const isMobile = /iPhone|iPad|Android/i.test(navigator.userAgent);

// Initial setting of URL parameter

searchParams.set("mode", isMobile ? "inspect" : "explore");

if (isMobile) {

    content?.addEventListener("click", highlighting);
    info?.addEventListener("click", highlighting3rdcolumn);

} else {

    content?.addEventListener("mouseover", highlighting);
    info?.addEventListener("mouseover", highlighting3rdcolumn);

}

myurl.search = searchParams.toString();
window.history.pushState({}, '', myurl);

document.querySelector<HTMLElement>("#setMode")?.addEventListener("click", (event) => {
    const target = event.currentTarget as HTMLElement;
    target.classList.toggle("active-view-icon");

    if (target.classList.contains("active-view-icon")) {

        searchParams.set("mode", "inspect");
        content?.removeEventListener("mouseover", highlighting);
        content?.addEventListener("click", highlighting);

        info?.removeEventListener("mouseover", highlighting3rdcolumn);
        info?.addEventListener("click", highlighting3rdcolumn);

    } else {

        searchParams.set("mode", "explore");
        content?.removeEventListener("click", highlighting);
        content?.addEventListener("mouseover", highlighting);

        info?.removeEventListener("click", highlighting3rdcolumn);
        info?.addEventListener("mouseover", highlighting3rdcolumn);

    }

    myurl.search = searchParams.toString();
    window.history.pushState({}, '', myurl);
});


function highlighting(event: Event) {

    console.log("Mode: Explore connections between annotations and text. Loaded!");

    const color = "connection-color";
    
    const target = event.target as HTMLElement;

    const anchorData = target.dataset.anchor;
    const targetDataList = target.dataset.target;
    const handDataList = target.dataset.hand;

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

            target.classList.remove(color);
            target.classList.add(color);

            anchorElements.forEach((el) => {

                el.classList.remove(color);
                el.classList.add(color);

                if (el.classList.contains("note") || el.classList.contains("quotes")) {

                    const children = el.querySelectorAll<HTMLElement>("*");

                    children.forEach((child) => {

                        if (child instanceof HTMLElement) {

                            child.classList.remove(color);
                            child.classList.add(color);

                        }

                    });

                }
            
            });

        }

        const targetElements = document.querySelectorAll<HTMLElement>(`[data-target~="${data}"]`);
        if (targetElements.length > 0) {

            target.classList.remove(color);
            target.classList.add(color);

            targetElements.forEach((el) => {

                el.classList.remove(color);
                el.classList.add(color);

                if (el.classList.contains("note") || el.classList.contains("quotes")) {

                    const children = el.querySelectorAll<HTMLElement>("*");

                    children.forEach((child) => {

                        if (child instanceof HTMLElement) {

                            child.classList.remove(color);
                            child.classList.add(color);

                        }

                    });

                }

            });
        }

    });

    const targetIds = targetDataList ? targetDataList.split(" ") : [];
    // highlight targets
    targetIds.forEach((targetId) => {

        const targetElements = document.querySelectorAll<HTMLElement>(`[data-anchor~="${targetId}"]`);

        if(targetElements.length > 0) {

            target.classList.remove(color);
            target.classList.add(color);

            targetElements.forEach((el) => {

                el.classList.remove(color);
                el.classList.add(color);

                if (el.classList.contains("note") || el.classList.contains("quotes")) {

                    const children = el.querySelectorAll<HTMLElement>("*");

                    children.forEach((child) => {

                        if (child instanceof HTMLElement) {

                            child.classList.remove(color);
                            child.classList.add(color);

                        }

                    });

                }

            });
        }

    });

    const handIds = handDataList ? handDataList.split(" ") : [];

    // highlight hands
    handIds.forEach((handId) => {

        const handElements = document.querySelectorAll<HTMLElement>(`[data-link~="${handId}"]`);

        if(handElements.length > 0) {

            target.classList.remove(color);
            target.classList.add(color);

            handElements.forEach((el) => {

                el.classList.remove(color);
                el.classList.add(color);

            });

        }

    });

}

function highlighting3rdcolumn (event: Event) {

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

                if (el.classList.contains("note") || el.classList.contains("quotes")) {

                    const children = el.querySelectorAll<HTMLElement>("*");

                    children.forEach((child) => {

                        if (child instanceof HTMLElement) {

                            child.classList.remove(color);
                            child.classList.add(color);

                        }

                    });

                }
            
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

                if (el.classList.contains("note") || el.classList.contains("quotes")) {

                    const children = el.querySelectorAll<HTMLElement>("*");

                    children.forEach((child) => {

                        if (child instanceof HTMLElement) {

                            child.classList.remove(color);
                            child.classList.add(color);

                        }

                    });

                }
                
                
            });
        }
    });

}

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