// Description: This script is used to connect elements in 
// left and right margin with their anchor in the text.

const connectElements = (query: string, container: boolean) => {

    const elements = document.querySelectorAll<HTMLElement>(query);

    [...elements].map((el) => {

        let targetId = el.id;
        const targetClassList = el.classList;
        
        if (container) {
            targetId = el.id.replace("container-", "");
        } else {
            targetId = "container-" + el.id;
        }

        if (targetId.length > 0) {

            const color = [...targetClassList].includes("metamark") ? "bg-danger-subtle" : [...targetClassList].includes("add") ? "bg-warning-subtle" : "bg-secondary-subtle";
            const border = [...targetClassList].includes("metamark") ? "border-danger-subtle" : [...targetClassList].includes("add") ? "border-warning-subtle" : "border-secondary-subtle";
            
            const target = document.getElementById(targetId);

            const childT = findChild(el, "target");
            const childS = findChild(el, "spanto");

            const spanToElement = checkForConnections(childS, "spanto");
            const targetElement = checkForConnections(childT, "target");

            // console.log(`Connecting ${anchorId} to ${anchor_target_id ? anchor_target_id : "null"}`);
            // anchor !== null ? console.log(anchor_target) : "";
            // filter out element that do not contain the class lineLeft, lineRight, doubleLineLeft, boubleLineRight

            if (childS && childS.classList.contains("lineLeft") 
                || childS && childS.classList.contains("lineRight") 
                || childS && childS.classList.contains("doubleLineLeft") 
                || childS && childS.classList.contains("doubleLineRight")
            ) {

                spanToElement
                    .map(span => {
                        createCanvas(el);
                        drawLine(el, span);
                        // span?.classList.add(...["border", border, "border-2", "border-dotted"])
                    });

            } else {

                spanToElement
                    .map(span => span?.classList.add(...["border", border, "border-2", "border-dotted"]));
            
            }

            el.onmouseover = (e) => {

                e.preventDefault();

                // console.log(`Connecting ${el.id} to ${targetId}`);
                
                if (!childS) {
                    target?.classList.add(color);
                    el.classList.add(color);
                    targetElement.map(target => target?.classList.add(...["border", border, "border-2", "border-dotted"]));
                }
                
            };

            el.onmouseout = (e) => {

                e.preventDefault();

                if (!childS) {
                    target?.classList.remove(color);
                    el.classList.remove(color);
                    targetElement.map(target => target?.classList.remove(...["border", border, "border-2", "border-dotted"]));
                }

            };
        }
    });
};

const findChild = (element: HTMLElement, type: string) => {

    const child = element.classList.contains(type) && element.tagName === "DIV" ? element.childNodes[0].childNodes[0] as HTMLElement 
    : element.classList.contains(type) && element.tagName !== "DIV" ? element.childNodes[0] as HTMLElement
    : false;

    return child;
}

const checkForConnections = (element: HTMLElement | false, type: string) => {

    const isConnected = element ? element : false;

    const connectedDataValue = isConnected ? isConnected.dataset[type] : false;
    const connectedIdList = connectedDataValue ? connectedDataValue.split(" ") : [];

    const connectedElements = connectedIdList.map((connectedId) => {
        const connectedIdNorm = connectedId.replace(type + "-", "");
        const connectedElement = document.getElementById(connectedIdNorm);
        return connectedElement;
    });

    return connectedElements;
};

// const removeCanvas = (element: HTMLElement) => {
//     const canvas = document.getElementById("canvas" + element.id);
//     if (canvas) {
//         canvas.remove();
//     }
// }

const createCanvas = (element: HTMLElement) => {
    const canvas = document.createElement("canvas");
    canvas.id = "canvas" + element.id;
    canvas.style.position = "absolute";
    element.childNodes[0].appendChild(canvas);
}

const drawLine = (element: HTMLElement, target: HTMLElement | null) => {
    const canvas = document.getElementById("canvas" + element.id) as HTMLCanvasElement;
    const ctx = canvas.getContext("2d");
    const rect = element.getBoundingClientRect();
    const targetRect = target?.getBoundingClientRect();
    const x1 = 0;
    const y1 = 0;
    const x2 = 0;
    const y2 = targetRect ? targetRect.top - rect.top + 15 : 0;

    canvas.width = targetRect ? rect.width : 0;
    canvas.height = targetRect ? targetRect.top - rect.top + 15 : 0;

    if (ctx) {
        ctx.beginPath();
        ctx.moveTo(x1, y1);
        ctx.lineTo(x2, y2);
        ctx.strokeStyle = "#ff8181";
        ctx.lineWidth = 5;
        ctx.stroke();
    }
}

connectElements("div.connect", true);
connectElements("span.connect", false);