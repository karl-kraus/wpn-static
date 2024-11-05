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
            const border = targetId.includes("-mm-") ? "border-danger-subtle" : targetId.includes("-add-") ? "border-danger-subtle" : "border-danger-subtle";

            const target = document.getElementById(targetId);

            if (target) {

                const anchor = el.classList.contains("anchor") ? el.childNodes[0].childNodes[0] as HTMLElement : null;
    
                const anchorId = anchor !== null ? anchor.id : "";
    
                const anchor_target_id = anchorId.length > 0 ? anchorId.replace("anchor-", "") : null;
                const anchor_target = anchor_target_id !== null ? document.getElementById(anchor_target_id) : null;
                

                el.onmouseover = () => {
                    // console.log(`Connecting ${el.id} to ${targetId}`);
                    target.classList.add(...["border", "border-4", border, "border-dotted"]);
                    el.classList.add(color);

                    // console.log(`Connecting ${anchorId} to ${anchor_target_id ? anchor_target_id : "null"}`);
                    // anchor !== null ? console.log(anchor_target) : "";

                    if (anchor_target) {
                        anchor_target.classList.add(...["border", "border-4", "border-danger-subtle", "border-dotted"]);    
                    }
                    
                };
                el.onmouseout = () => {
                    target.classList.remove(...["border", "border-4", border, "border-dotted"]);
                    el.classList.remove(color);

                    if (anchor_target) {
                        anchor_target.classList.remove(...["border", "border-4", "border-danger-subtle", "border-dotted"]);    
                    }

                };
            }
        }
    });
};

connectElements("div.connect", true);
connectElements("span.connect", false);