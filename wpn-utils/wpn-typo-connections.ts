// Description: This script is used to connect elements in 
// left and right margin with their anchor in the text.
const myurl = new URL(window.location.href);
const searchParams = new URLSearchParams(myurl.search);
const content = document.querySelector<HTMLElement>("#print-page");
const info = document.querySelector<HTMLElement>("#infocontent-pb");
const setModeButton = document.querySelector<HTMLElement>("#setMode");
const highlightedClass = "connection-color";
const highlightedClassLine = "connection-color-line";
const debounceDelayText = 750;
const debounceDelayInfo = 0;

// Global event handlers storage
const _eventHandlers: any = {}; // somewhere global

const addListener = (node: HTMLElement, event: string, handler: EventListenerOrEventListenerObject, capture = false) => {
    if (!(event in _eventHandlers)) {
        _eventHandlers[event] = []
    }
    // here we track the events and their nodes (note that we cannot
    // use node as Object keys, as they'd get coerced into a string
    _eventHandlers[event].push({ node: node, handler: handler, capture: capture })
    node.addEventListener(event, handler, capture)
}

const removeAllListeners = (targetNode: HTMLElement, event: string) => {
    // remove listeners from the matching nodes
    _eventHandlers[event]
        .filter(({ node }: any) => node === targetNode)
        .forEach(({ node, handler, capture }: any) => node.removeEventListener(event, handler, capture))

    // update _eventHandlers global
    _eventHandlers[event] = _eventHandlers[event].filter(
        ({ node }: any) => node !== targetNode,
    )
}

// Default mode: explore for Desktop
// Default mode: inspect for Mobile

const isMobile = /iPhone|iPad|Android/i.test(navigator.userAgent);

// Initial setting of URL parameter

searchParams.set("mode", isMobile ? "inspect" : "explore");

if (isMobile) {

    console.log("Mode: Inspect connections between annotations and text. Loaded!");
    addListener(content!, "click", highlighting);
    addListener(info!, "click", highlighting3rdcolumn);
    // content?.addEventListener("click", highlighting);
    // info?.addEventListener("click", highlighting3rdcolumn);

} else {

    console.log("Mode: Explore connections between annotations and text. Loaded!");

    addListener(content!, "mouseover", debounce(highlighting, debounceDelayText));
    addListener(info!, "mouseover", debounce(highlighting3rdcolumn, debounceDelayInfo));
    // content?.addEventListener("mouseover", debounce(highlighting, debounceDelayText));
    // info?.addEventListener("mouseover", debounce(highlighting3rdcolumn, debounceDelayInfo));

}

myurl.search = searchParams.toString();
window.history.pushState({}, '', myurl);

setModeButton!.addEventListener("click", () => {

    setModeButton!.classList.toggle("active-view-icon");

    if (setModeButton!.classList.contains("active-view-icon")) {

        setModeButton!.style.color = "white";

        console.log("Mode: Inspect connections between annotations and text. Loaded!");

        searchParams.set("mode", "inspect");
        removeAllListeners(content!, "mouseover");
        // content?.removeEventListener("mouseover", debounce(highlighting, debounceDelayText));
        addListener(content!, "click", highlighting);
        // content?.addEventListener("click", highlighting);

        removeAllListeners(info!, "mouseover");
        // info?.removeEventListener("mouseover", debounce(highlighting3rdcolumn, debounceDelayInfo));
        addListener(info!, "click", highlighting3rdcolumn);
        // info?.addEventListener("click", highlighting3rdcolumn);

    } else {

        setModeButton!.style.color = "black";
        console.log("Mode: Explore connections between annotations and text. Loaded!");

        searchParams.set("mode", "explore");

        removeAllListeners(content!, "click");
        //content?.removeEventListener("click", highlighting);
        addListener(content!, "mouseover", debounce(highlighting, debounceDelayText));
        // content?.addEventListener("mouseover", debounce(highlighting, debounceDelayText));

        removeAllListeners(info!, "click");
        // info?.removeEventListener("click", highlighting3rdcolumn);
        addListener(info!, "mouseover", debounce(highlighting3rdcolumn, debounceDelayInfo));
        // info?.addEventListener("mouseover", debounce(highlighting3rdcolumn, debounceDelayInfo));

    }

    myurl.search = searchParams.toString();
    window.history.pushState({}, '', myurl);

});


function highlighting(event: Event) {

    const color = highlightedClass;

    const color_line = highlightedClassLine;
    
    const target = event.target as HTMLElement;

    const anchorData = target.dataset.anchor;

    const targetDataList = target.dataset.target;

    const handDataList = target.dataset.hand;

    document.querySelectorAll<HTMLElement>(`.${color}`).forEach((el) => {

        el.classList.remove(color);

    });

    document.querySelectorAll<HTMLElement>(`.${color_line}.active`).forEach((el) => {

        el.classList.remove("active");

    });

    const anchorDataList = anchorData ? anchorData.split(" ") : [];
    anchorDataList.forEach((data) => {

        // highlight anchor
        const anchorElements = document.querySelectorAll<HTMLElement>(`[data-anchor~="${data}"]`);

        if(anchorElements.length > 1) {

            target.classList.add(color);

            if (target.classList.contains("note") || target.classList.contains("quotes")) {

                markChildrenAsHighlighted(target, color);

            }

            anchorElements.forEach((el) => {

                if (el.classList.contains("printSpanFrom") || el.classList.contains("printSpanTo")) {

                    el.classList.add("active");
                    if (el.classList.contains("note") || el.classList.contains("quotes")) {

                        markChildrenAsHighlighted(el, color);

                    }

                } else {

                    el.classList.add(color);
                    if (el.classList.contains("note") || el.classList.contains("quotes")) {

                        markChildrenAsHighlighted(el, color);

                    }

                }

            });

        }

        const targetElements = document.querySelectorAll<HTMLElement>(`[data-target~="${data}"]`);
        if (targetElements.length > 0) {

            target.classList.add(color);

            if (target.classList.contains("note") || target.classList.contains("quotes")) {

                markChildrenAsHighlighted(target, color);

            }

            targetElements.forEach((el) => {

                el.classList.add(color);

                if (el.classList.contains("note") || el.classList.contains("quotes")) {

                    markChildrenAsHighlighted(el, color);

                }

            });
        }

        const linkElements = document.querySelectorAll<HTMLElement>(`[data-link~="${data}"]`);
        if (linkElements.length > 0) {

            target.classList.add(color);

            if (target.classList.contains("note") || target.classList.contains("quotes")) {

                markChildrenAsHighlighted(target, color);

            }

            linkElements.forEach((el) => {

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

            target.classList.add(color);

            if (target.classList.contains("note") || target.classList.contains("quotes")) {

                markChildrenAsHighlighted(target, color);

            }

            targetElements.forEach((el) => {

                el.classList.add(color);

                if (el.classList.contains("note") || el.classList.contains("quotes")) {

                    markChildrenAsHighlighted(el, color);

                }

            });
        }

    });

    const handIds = handDataList ? handDataList.split(" ") : [];

    // highlight hands
    handIds.forEach((handId) => {

        const handElements = document.querySelectorAll<HTMLElement>(`[data-link~="${handId}"]`);

        if(handElements.length > 0) {

            target.classList.add(color);

            handElements.forEach((el) => {

                el.classList.add(color);

            });

        }

    });

}

function highlighting3rdcolumn (event: Event) {

    const color = highlightedClass;
    const color_line = highlightedClassLine;
    const target = event.target as HTMLElement;
    const dataLink = target.dataset.link;
    const dataLinkOne = target.dataset.linkone;
    const dataOverwritten = target.dataset.overwritten;

    document.querySelectorAll<HTMLElement>(`.${color}`).forEach((el) => {

        el.classList.remove(color);

    });
    document.querySelectorAll<HTMLElement>(`.${color_line}.active`).forEach((el) => {

        el.classList.remove("active");

    });

    const dataLinkList = dataLink ? dataLink.split(" ") : [];

    dataLinkList.forEach((link) => {

        // highlight anchor
        const anchorElements = document.querySelectorAll<HTMLElement>(`[data-hand~="${link}"]`);

        if(anchorElements.length > 0) {

            markChildrenAsHighlighted(target, color);
            target.classList.add(color);

            anchorElements.forEach((el) => {

                el.classList.add(color);
            
            });

        }

        // highlight linked elements
        const linkedElements = document.querySelectorAll<HTMLElement>(`[data-anchor~="${link}"]`);

        if(linkedElements.length > 0) {

            markChildrenAsHighlighted(target, "active");
            target.classList.add("active");

            linkedElements.forEach((el) => {

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

            markChildrenAsHighlighted(target, color);
            target.classList.add(color);
            
            linkedElements.forEach((el) => {

                el.classList.add(color);

                if (el.classList.contains("note") || el.classList.contains("quotes")) {

                    markChildrenAsHighlighted(el, color);

                }
                
                
            });
        }
    });

    const dataOverwrittenList = dataOverwritten ? dataOverwritten.split(" ") : [];
    
    dataOverwrittenList.forEach((overwritten) => {
        // highlight linked elements
        const overwrittenElements = document.querySelectorAll<HTMLElement>(`.subst.overwrittenAnchor.${overwritten}`);
        if(overwrittenElements.length > 0) {

            markChildrenAsHighlighted(target, color);
            target.classList.add(color);
            
            overwrittenElements.forEach((el) => {

                el.classList.add(color);

                if (el.classList.contains("note") || el.classList.contains("quotes")) {

                    markChildrenAsHighlighted(el, color);

                }
                
            });
        }
    });

}

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

            child.classList.add(color);

        }

    });
}