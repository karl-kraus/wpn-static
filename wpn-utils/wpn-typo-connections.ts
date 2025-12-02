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

    console.log("Mode: Inspect connections between annotations and text. Loaded!");

    content?.addEventListener("click", debounce(highlighting, 300));
    info?.addEventListener("click", debounce(highlighting3rdcolumn, 300));

} else {

    console.log("Mode: Explore connections between annotations and text. Loaded!");

    content?.addEventListener("mouseover", debounce(highlighting, 300));
    info?.addEventListener("mouseover", debounce(highlighting3rdcolumn, 300));

}

myurl.search = searchParams.toString();
window.history.pushState({}, '', myurl);

document.querySelector<HTMLElement>("#setMode")?.addEventListener("click", (event) => {

    const target = event.currentTarget as HTMLElement;
    target.classList.toggle("active-view-icon");

    if (target.classList.contains("active-view-icon")) {

        target.style.color = "white";

        console.log("Mode: Inspect connections between annotations and text. Loaded!");

        searchParams.set("mode", "inspect");
        content?.removeEventListener("mouseover", debounce(highlighting, 300));
        content?.addEventListener("click", debounce(highlighting, 300));

        info?.removeEventListener("mouseover", debounce(highlighting3rdcolumn, 300));
        info?.addEventListener("click", debounce(highlighting3rdcolumn, 300));
    } else {

        target.style.color = "black";
        console.log("Mode: Explore connections between annotations and text. Loaded!");

        searchParams.set("mode", "explore");
        content?.removeEventListener("click", debounce(highlighting, 300));
        content?.addEventListener("mouseover", debounce(highlighting, 300));

        info?.removeEventListener("click", debounce(highlighting3rdcolumn, 300));
        info?.addEventListener("mouseover", debounce(highlighting3rdcolumn, 300));
    }

    myurl.search = searchParams.toString();
    window.history.pushState({}, '', myurl);
});


function highlighting(event: Event) {

    const color = "connection-color";
    
    const target = event.target as HTMLElement;
    console.log("Target:", target);

    const anchorData = target.dataset.anchor;
    console.log("Anchor Data:", anchorData);

    const targetDataList = target.dataset.target;
    console.log("Target Data:", targetDataList);

    //const handDataList = target.dataset.hand;
      let handDataList;
    
    document.querySelectorAll<HTMLElement>(`.${color}`).forEach((el) => {

        el.classList.remove(color);

    });

    const hovered: HTMLElement | null = document.querySelector(`[data-hand]:not([data-hand=""]):hover, [data-hand]:not([data-hand=""]):has(*[data-anchor]:hover)`);
    if (hovered) {
        handDataList = [];
        hovered.classList.remove(color);
        hovered.classList.add(color);
        handDataList = hovered.dataset.hand;
        markChildrenAsHighlighted(hovered, color);
    }

    /*const anchorDataList = anchorData ? anchorData.split(" ") : [];
    anchorDataList.forEach((data) => {

        // highlight anchor
        const anchorElements = document.querySelectorAll<HTMLElement>(`[data-anchor~="${data}"]`);

        if(anchorElements.length > 1) {

            target.classList.remove(color);
            target.classList.add(color);

            if (target.classList.contains("note") || target.classList.contains("quotes")) {

                markChildrenAsHighlighted(target, color);

            }

            anchorElements.forEach((el) => {

                el.classList.remove(color);
                el.classList.add(color);

                if (el.classList.contains("note") || el.classList.contains("quotes")) {

                    markChildrenAsHighlighted(el, color);

                }
            
            });

        }

        const targetElements = document.querySelectorAll<HTMLElement>(`[data-target~="${data}"]`);
        if (targetElements.length > 0) {

            target.classList.remove(color);
            target.classList.add(color);

            if (target.classList.contains("note") || target.classList.contains("quotes")) {

                markChildrenAsHighlighted(target, color);

            }

            targetElements.forEach((el) => {

                el.classList.remove(color);
                el.classList.add(color);

                if (el.classList.contains("note") || el.classList.contains("quotes")) {

                    markChildrenAsHighlighted(el, color);

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

            if (target.classList.contains("note") || target.classList.contains("quotes")) {

                markChildrenAsHighlighted(target, color);

            }

            targetElements.forEach((el) => {

                el.classList.remove(color);
                el.classList.add(color);

                if (el.classList.contains("note") || el.classList.contains("quotes")) {

                    markChildrenAsHighlighted(el, color);

                }

            });
        }

    });*/

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

                    markChildrenAsHighlighted(el, color);

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

                    markChildrenAsHighlighted(el, color);

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

function debounce(func: Function, wait: number) {
    let timeout: number | undefined;
    return function(...args: any[]) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = window.setTimeout(later, wait);
    };
}

function markChildrenAsHighlighted(element: HTMLElement, color: string) {
    const children = element.querySelectorAll<HTMLElement>("*");

    children.forEach((child) => {

        if (child instanceof HTMLElement) {

            child.classList.remove(color);
            child.classList.add(color);

        }

    });
}