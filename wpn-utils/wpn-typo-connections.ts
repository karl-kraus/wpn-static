// Description: This script is used to connect elements in 
// left and right margin with their anchor in the text.
const myurl = new URL(window.location.href);
const searchParams = new URLSearchParams(myurl.search);
const content = document.querySelector<HTMLElement>("#print-page");
const info = document.querySelector<HTMLElement>("#infocontent-pb");
const setModeButton = document.querySelector<HTMLElement>("#setMode");
const highlightedClass = "connection-color";
const highlightedClassLine = "connection-color-line";
const debounceDelayText = 60;
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

searchParams.set("mode", isMobile ? "inspect" : searchParams.get("mode") || "off");

if (isMobile) {

    console.log("Mode: Inspect connections between annotations and text. Loaded!");
    addListener(content!, "click", highlighting);
    addListener(info!, "click", highlighting3rdcolumn);

    setModeButton!.style.display = "none";

}
if (searchParams.get("mode") === "explore") {

    setModeButton!.classList.add("active-view-icon");
    setModeButton!.style.color = "white";
    addListener(content!, "mouseover", debounce(highlighting, debounceDelayText));
    addListener(info!, "mouseover", debounce(highlighting3rdcolumn, debounceDelayInfo));

}

myurl.search = searchParams.toString();
window.history.pushState({}, '', myurl);

setModeButton!.addEventListener("click", () => {

    if (isMobile) {
        // on mobile, do nothing, as default is inspect
        return;
    }

    setModeButton!.classList.toggle("active-view-icon");

    if (setModeButton!.classList.contains("active-view-icon")) {

        setModeButton!.style.color = "white";

        console.log("Mode: Inspect connections between annotations and text. Loaded!");

        searchParams.set("mode", "explore");
        // removeAllListeners(content!, "mouseover");
        addListener(content!, "mouseover", debounce(highlighting, debounceDelayText));

        // removeAllListeners(info!, "mouseover");
        addListener(info!, "mouseover", debounce(highlighting3rdcolumn, debounceDelayInfo));

    } else {

        setModeButton!.style.color = "black";
        // console.log("Mode: Explore connections between annotations and text. Loaded!");

        searchParams.set("mode", "off");

        removeAllListeners(content!, "mouseover");
        // addListener(content!, "mouseover", debounce(highlighting, debounceDelayText));

        removeAllListeners(info!, "mouseover");
        // addListener(info!, "mouseover", debounce(highlighting3rdcolumn, debounceDelayInfo));

    }

    myurl.search = searchParams.toString();
    window.history.pushState({}, '', myurl);

});


function highlighting(event: Event) {

    const color = highlightedClass;

    const color_line = highlightedClassLine;
    
    // old: const target = event.target as HTMLElement;
    const target = resolveEffectiveTarget(event.target as HTMLElement);

    const anchorData = target.dataset.anchor;

    // old: const targetDataList = target.dataset.target;
    const targetDataList = [target.dataset.target, ...collectAncestorTarget(target)].filter(Boolean).join(" ");

    // old: const handDataList = target.dataset.hand;
    const handDataList = [target.dataset.hand, ...collectAncestorHand(target)].filter(Boolean).join(" ");

    document.querySelectorAll<HTMLElement>(`.${color}`).forEach((el) => {

        el.classList.remove(color);

    });

    document.querySelectorAll<HTMLElement>(`.${color_line}.active`).forEach((el) => {

        el.classList.remove("active");

    });

    const targetHasOwnIdentity = hasOwnIdentity(target);

    // Manche Container-Templates (z.B. tei:metamark[@function='printInstruction'][@rendition]
    // in typo-metamark.xsl) vererben - anders als typo-del.xsl/typo-add.xsl und die
    // span[@n='last']/[@n='firstLast']-Templates in editions_typo.xsl - die id der umgebenden
    // note nicht in den eigenen data-anchor. Ein solcher Container ohne eigene Identität soll
    // trotzdem wie "note hovern" wirken, auch wenn sein eigener data-anchor die note gar nicht
    // referenziert.
    if (!targetHasOwnIdentity) {
        const noteAncestor = target.closest<HTMLElement>(".note");
        if (noteAncestor) {
            noteAncestor.classList.add(color);
            markChildrenAsHighlighted(noteAncestor, color);
        }
    }

    const anchorDataList = anchorData ? anchorData.split(" ") : [];
    anchorDataList.forEach((data) => {

        if (targetHasOwnIdentity && isSuppressedNoteToken(data, target)) return;

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
                el.classList.add("active");
            
            });

        }

        // highlight linked elements
        const linkedElements = document.querySelectorAll<HTMLElement>(`[data-anchor~="${link}"]`);

        if(linkedElements.length > 0) {

            markChildrenAsHighlighted(target, link.includes("note") ? color : "active");
            target.classList.add(color);

            linkedElements.forEach((el) => {

                el.classList.add(link.includes("note") ? color : "active");
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

                if (el.classList.contains("note") || el.classList.contains("quotes") || el.classList.contains("subst")) {

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

// helper functions
function normalize(s) {
    return (s || "").replace(/\|/g, "").replace(/\s+/g, " ").trim();
}

function getNoteElementForToken(token: string): HTMLElement | null {
    return document.querySelector<HTMLElement>(`.note[data-anchor~="${token}"]`);
}

// Ein data-anchor-Token ist entweder die eigene id eines Elements (z.B. das del/add-Paar
// bei subst, mit bewusst unterschiedlichem Text) oder die geerbte id der umgebenden note
// (siehe $inheritIDfromNote in typo-del.xsl/typo-add.xsl bzw. die analoge Logik in
// editions_typo.xsl für span[@n='last']/[@n='firstLast']). Nur im zweiten Fall soll das
// Token verbinden, wenn die note (bereinigt) keinen weiteren Text als das Hover-Element
// selbst enthält - sonst verbindet ein und dasselbe Note-Token unbeteiligte
// Geschwister-Elemente (bzw. die ganze note) miteinander statt nur das eine Element.
// Hover direkt auf die note bleibt davon unberührt (dort ist el === target, Text ist gleich).
function isSuppressedNoteToken(token: string, target: HTMLElement): boolean {
    const noteEl = getNoteElementForToken(token);
    if (!noteEl) return false;
    return normalize(noteEl.textContent) !== normalize(target.textContent);
}

// note- und metamark-Templates mischen (siehe $inheritIDfromNote in typo-del.xsl/typo-add.xsl,
// parent::tei:metamark[@xml:id] in editions_typo.xsl) die id des umgebenden Containers in
// data-anchor jedes Kind-Elements. Reine Fließtext-Wrapper (z.B. span[@n='last']/[@n='firstLast'],
// die nur der Zeilenumbruch-Logik dienen) haben dadurch GAR KEINE eigene id - ihre komplette
// data-anchor-Kennung besteht nur aus geerbten Container-ids. Ein del/add mit echtem @xml:id hat
// dagegen zusätzlich eine eigene, nicht geerbte id. Nur wenn das Hover-Element eine solche eigene
// Identität hat, soll isSuppressedNoteToken greifen - reiner Fließtext soll die note wie gehabt
// immer komplett aufleuchten lassen (das IST ja schlicht "die note hovern").
function collectAncestorContainerIds(el: HTMLElement): Set<string> {
    const ids = new Set<string>();
    let node = el.parentElement;
    while (node && node !== content) {
        if ((node.classList.contains("note") || node.classList.contains("metamark")) && node.dataset.anchor) {
            node.dataset.anchor.split(" ").filter(Boolean).forEach((t) => ids.add(t));
        }
        node = node.parentElement;
    }
    return ids;
}

function hasOwnIdentity(target: HTMLElement): boolean {
    // Ein Container selbst (note/metamark) repräsentiert keine eigene, unterscheidbare
    // Editionsentität wie ein del/add - seine eigene id ist nur die des Containers, den er
    // selbst darstellt, kein Zeichen "eigener Identität". Ausnahme: ein metamark mit einer
    // anderen Hand/Schicht (data-hand) als die umgebende note (z.B. eine spätere Bleistift-
    // Randziffer in einer mit Tinte geschriebenen note) ist inhaltlich eine eigenständige,
    // von der note unabhängige Entität und soll separat bleiben statt mit der note zu
    // verschmelzen.
    if (target.classList.contains("note")) return false;
    if (target.classList.contains("metamark")) {
        const noteAncestor = target.closest<HTMLElement>(".note");
        const noteHand = noteAncestor?.dataset.hand;
        const ownHand = target.dataset.hand;
        if (noteAncestor && noteHand && ownHand && noteHand !== ownHand) return true;
        return false;
    }
    const inherited = collectAncestorContainerIds(target);
    const ownTokens = (target.dataset.anchor || "").split(" ").filter(Boolean);
    return ownTokens.some((tok) => !inherited.has(tok));
}

function collectAncestorHand(el) {
    const collected = [];
    if (el.classList.contains("metamark") && el.dataset.hand && el.closest(".note")) {
        return collected; // Metamark mit eigenem Hand-Wert in einer Note: Ancestor-Hand nicht zusätzlich berücksichtigen
    }
    let node = el.parentElement;
    while (node && node !== content) {
        if (node.dataset.hand) collected.push(node.dataset.hand);
        node = node.parentElement;
    }
    return collected;
}

function collectAncestorTarget(el) {
    const collected = [];
    const leafText = normalize(el.textContent);
    let node = el.parentElement;
    while (node && node !== content) {
        if (normalize(node.textContent) !== leafText) break;
        if (node.dataset.target) collected.push(node.dataset.target);
        node = node.parentElement;
    }
    return collected;
}

const alwaysSkipClasses = ["quotes"]; // hier künftig weitere Klassen ergänzbar

function hasNoOwnData(node: HTMLElement): boolean {
    const anchor = node.dataset.anchor;
    const hand = node.dataset.hand;
    const hasAnchor = !!anchor && anchor.trim().length > 0;
    const hasHand = !!hand && hand.trim().length > 0;
    return !hasAnchor && !hasHand;
}

function isSkippableWrapper(node: HTMLElement): boolean {
    // 1. Klassen, die unabhängig von eigenen Daten immer übersprungen werden
    if (alwaysSkipClasses.some(cls => node.classList.contains(cls))) return true;

    // 2. Struktur-Wrapper (Versgruppe/Verszeile)
    if (node.classList.contains("d-block") && (node.classList.contains("lg") || node.classList.contains("l"))) return true;

    // 3. Textlauf-Wrapper direkt in einer Verszeile
    const parent = node.parentElement;
    const isInlineText = node.classList.contains("inline-text");
    const parentIsL = parent && parent.classList.contains("d-block") && parent.classList.contains("l");
    if (isInlineText && parentIsL) return true;

    // 4. Elemente ganz ohne eigene Anker-/Hand-Daten
    return hasNoOwnData(node);
}

function resolveEffectiveTarget(el: HTMLElement): HTMLElement {
    let node = el;
    while (node && node !== content && isSkippableWrapper(node)) {
        node = node.parentElement as HTMLElement;
    }
    return node;
}
