const connectElements = (query: string, container: boolean) => {
    const elements = document.querySelectorAll<HTMLElement>(query);
    // console.log([...elements]);
    [...elements].map((el) => {
        let targetId = el.id;
        if (container) {
            targetId = el.id.replace("container-", "");
        } else {
            targetId = "container-" + el.id;
        }
        if (targetId.length > 0) {

            const color = targetId.includes("-mm-") ? "bg-danger-subtle" : targetId.includes("-add-") ? "bg-warning-subtle" : "bg-secondary-subtle";
            const border = targetId.includes("-mm-") ? "border-danger-subtle" : targetId.includes("-add-") ? "border-warning-subtle" : "border-secondary-subtle";
            const target = document.getElementById(targetId);

            if (target) {

                const spanToElement = checkForConnections(el, "spanto");
                const targetElement = checkForConnections(el, "target");

                el.onmouseover = () => {
                    // console.log(`Connecting ${el.id} to ${targetId}`);
                    target.classList.add(...["border", border, "border-2", "border-dotted"]);
                    el.classList.add(color);

                    // console.log(`Connecting ${anchorId} to ${anchor_target_id ? anchor_target_id : "null"}`);
                    // anchor !== null ? console.log(anchor_target) : "";

                    spanToElement.map(el => el?.classList.add(...["border", border, "border-2", "border-dotted"]));
                    targetElement.map(el => el?.classList.add(...["border", border, "border-2", "border-dotted"]));     
                    
                };
                el.onmouseout = () => {

                    target.classList.remove(...["border", border, "border-2", "border-dotted"]);
                    el.classList.remove(color);

                    spanToElement.map(el => el?.classList.remove(...["border", border, "border-2", "border-dotted"]));
                    targetElement.map(el => el?.classList.remove(...["border", border, "border-2", "border-dotted"]));   

                };
            }
        }
    });
};

const checkForConnections = (element: HTMLElement, type: string) => {

    const isConnected = element.classList.contains(type) ? element.childNodes[0].childNodes[0] as HTMLElement : false;
    const connectedDataValue = isConnected ? isConnected.dataset[type] : false;
    const connectedIdList = connectedDataValue ? connectedDataValue.split(" ") : [];

    const connectedElements = connectedIdList.map((connectedId) => {
        const connectedIdNorm = connectedId.replace(type + "-", "");
        const connectedElement = document.getElementById(connectedIdNorm);
        return connectedElement;
    });
    return connectedElements;
};

connectElements("div.connect", true);
connectElements("span.connect", false);