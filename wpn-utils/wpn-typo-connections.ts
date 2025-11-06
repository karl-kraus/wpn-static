// Description: This script is used to connect elements in 
// left and right margin with their anchor in the text.

const connectElements = (query: string, container: boolean) => {

    const color = "connection-color";
    // const border = "connection-color";
    const elements = document.querySelectorAll<HTMLElement>(query);

    [...elements].map((el) => {

        // margin element connection to text anchor
        // or text anchor connection to margin element
        var targetId: string = el.id;
        const targetClassList: DOMTokenList = el.classList;

        // elements can have multiple connections via data-target
        var datasetTargets: (HTMLElement | null)[] = [];
        var datasetTargetElement: HTMLElement | false = false;

        if (targetClassList.contains("target")) {
            datasetTargetElement = findChild(el, "target");
        }

        // inline text elements hold true ids, while margin containers have "container-" prefix
        if (container) {
            targetId = el.id.replace("container-", "");
        } else {
            targetId = "container-" + el.id;
        }

        const target = document.getElementById(targetId);
        if (datasetTargetElement) {
            datasetTargets = checkForConnections(datasetTargetElement, "target");
        }

        if (target && el && datasetTargets.length === 0) {
            
            el.onmouseover = (e) => {

                e.preventDefault();

                target.classList.add(color);
                el.classList.add(color);
                
            };

            el.onmouseout = (e) => {

                e.preventDefault();

                target.classList.remove(color);
                el.classList.remove(color);

            };

            target.onmouseover = (e) => {

                e.preventDefault();

                target.classList.add(color);
                el.classList.add(color);
                
            };

            target.onmouseout = (e) => {
                
                e.preventDefault();
                target.classList.remove(color);
                el.classList.remove(color);
                
            };
        } else if (target && el && datasetTargets.length > 0) {


            el.onmouseover = (e) => {

                e.preventDefault();

                target.classList.add(color);
                el.classList.add(color);
                datasetTargets.map(dt => dt?.classList.add(color));
                
            };

            el.onmouseout = (e) => {

                e.preventDefault();

                target.classList.remove(color);
                el.classList.remove(color);
                datasetTargets.map(dt => dt?.classList.remove(color));                

            };

            target.onmouseover = (e) => {

                e.preventDefault();

                target.classList.add(color);
                el.classList.add(color);
                datasetTargets.map(target => target?.classList.add(color));
                
            };

            target.onmouseout = (e) => {
                
                e.preventDefault();
                target.classList.remove(color);
                el.classList.remove(color);
                datasetTargets.map(dt => dt?.classList.remove(color));
                
            };

            datasetTargets.forEach((dt) => {

                if (!dt) return;

                dt.onmouseover = (e) => {

                    e.preventDefault();
                    
                    target.classList.add(color);
                    el.classList.add(color);
                    dt.classList.add(color);
                }
            });

            datasetTargets.forEach((dt) => {

                if (!dt) return;

                dt.onmouseout = (e) => {

                    e.preventDefault();
                    
                    target.classList.remove(color);
                    el.classList.remove(color);
                    dt.classList.remove(color);
                }
            });

        } else if (!target && el && datasetTargets.length > 0) {

            // if connection is a add element it should connect to previous and next del element
            const prevSibling = el.previousElementSibling as HTMLElement | null;
            const prevSiblingClassList = prevSibling ? prevSibling.classList : null;
            const nextSibling = el.nextElementSibling as HTMLElement | null;
            const nextSiblingClassList = nextSibling ? nextSibling.classList : null;

            if (prevSibling && prevSiblingClassList && prevSiblingClassList.contains("del")) {
                prevSibling.onmouseover = (e) => {

                    e.preventDefault();

                    prevSibling.classList.add(color);
                    datasetTargets.map(dt => dt?.classList.add(color));
                    
                };

                prevSibling.onmouseout = (e) => {

                    e.preventDefault();

                    prevSibling.classList.remove(color);
                    datasetTargets.map(dt => dt?.classList.remove(color));                

                };

                datasetTargets.forEach((dt) => {

                    if (!dt) return;

                    dt.onmouseover = (e) => {

                        e.preventDefault();
                        
                        prevSibling.classList.add(color);
                        dt.classList.add(color);
                    }
                });

                datasetTargets.forEach((dt) => {

                    if (!dt) return;

                    dt.onmouseout = (e) => {

                        e.preventDefault();
                        
                        prevSibling.classList.remove(color);
                        dt.classList.remove(color);
                    }
                });
            }

            if (nextSibling && nextSiblingClassList && nextSiblingClassList.contains("del")) {
                nextSibling.onmouseover = (e) => {

                    e.preventDefault();

                    nextSibling.classList.add(color);
                    datasetTargets.map(dt => dt?.classList.add(color));
                    
                };

                nextSibling.onmouseout = (e) => {

                    e.preventDefault();

                    nextSibling.classList.remove(color);
                    datasetTargets.map(dt => dt?.classList.remove(color));
                };

            }

            // other elements or most likely mod and metamark elements
            el.onmouseover = (e) => {

                e.preventDefault();

                el.classList.add(color);
                datasetTargets.map(dt => dt?.classList.add(color));
                
            };

            el.onmouseout = (e) => {

                e.preventDefault();

                el.classList.remove(color);
                datasetTargets.map(dt => dt?.classList.remove(color));                

            };

            datasetTargets.forEach((dt) => {

                if (!dt) return;

                dt.onmouseover = (e) => {

                    e.preventDefault();
                    
                    el.classList.add(color);
                    dt.classList.add(color);

                    if (prevSibling && prevSiblingClassList && prevSiblingClassList.contains("del")) {
                        prevSibling.classList.add(color);
                    }

                    if (nextSibling && nextSiblingClassList && nextSiblingClassList.contains("del")) {
                        nextSibling.classList.add(color);
                    }
                }
            });

            datasetTargets.forEach((dt) => {

                if (!dt) return;

                dt.onmouseout = (e) => {

                    e.preventDefault();
                    
                    el.classList.remove(color);
                    dt.classList.remove(color);

                    if (prevSibling && prevSiblingClassList && prevSiblingClassList.contains("del")) {
                        prevSibling.classList.remove(color);
                    }

                    if (nextSibling && nextSiblingClassList && nextSiblingClassList.contains("del")) {
                        nextSibling.classList.remove(color);
                    }
                }
            });
        }

    });
};

const findChild = (element: HTMLElement, type: string) => {

    let child: HTMLElement | false = false;

    if (element.classList.contains(type) && element.tagName === "DIV") {
        child = element.childNodes[0].childNodes[0] as HTMLElement;
    } else if (element.classList.contains(type) && element.tagName !== "DIV") {
        child = element.childNodes[0] as HTMLElement;
    }

    if (child === null || child === undefined) {
        console.log("Child was null: ", child);
        child = false;
    }

    return child;
}

const checkForConnections = (element: HTMLElement | false, type: string) => {

    if (!element) return [];
    const connectedDataValue = element.dataset[type] ? element.dataset[type] : false;

    if (!connectedDataValue) return [];
    const connectedIdList = connectedDataValue.split(" ");

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

// const createCanvas = (element: HTMLElement,
//                 double: boolean,
//                 x1: number,
//                 x2: number,
//                 lineRight: boolean,
//                 targetId: string,
//                 spanId: string) => {
//     const canvas = document.createElement("canvas");
//     if (double) {
//         canvas.classList.add("double");
//     }
//     canvas.dataset.target = targetId;
//     canvas.dataset.span = spanId;
//     canvas.dataset.x1 = x1.toString();
//     canvas.dataset.x2 = x2.toString();
//     canvas.id = "canvas" + element.id;
//     canvas.style.position = "absolute";
//     if (lineRight) {
//         canvas.style.left = "5%";
//     } else {
//         canvas.style.left = "75%";
//     }
//     element.childNodes[0].appendChild(canvas);
// }

// const drawLine = (element: HTMLElement, target: HTMLElement | null, double: boolean, count: number) => {
//     const canvas = document.getElementById("canvas" + element.id) as HTMLCanvasElement;
//     const ctx = canvas.getContext("2d");
//     const rect = element.getBoundingClientRect();
//     const targetRect = target?.getBoundingClientRect();
//     const x1 = count;
//     const y1 = 0;
//     const x2 = count;
//     const y2 = targetRect ? targetRect.top - rect.top + 15 : 0;

//     canvas.width = targetRect ? rect.width : 0;
//     canvas.height = targetRect ? targetRect.top - rect.top + 15 : 0;

//     if (ctx) {

//         ctx.beginPath();
//         ctx.moveTo(x1, y1);
//         ctx.lineTo(x2, y2);
//         ctx.strokeStyle = "#ff8181";
//         ctx.stroke();

//         if (double) {
//             // second line
//             ctx.beginPath();
//             ctx.moveTo(x1 + 5, y1);
//             ctx.lineTo(x2 + 5, y2);
//             ctx.strokeStyle = "#ff8181";
//             ctx.stroke();
//         }

//     }
// }

connectElements("div.connect", true);
connectElements("span.connect.target", false);