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
            
            const target = document.getElementById(targetId);
            if (target) {
                el.onmouseover = () => {
                    // console.log(`Connecting ${el.id} to ${targetId}`);
                    target.classList.add(...["border", "border-red-500", "border-dotted"]);
                    el.classList.add(...["border", "border-red-500", "border-dotted"]);
                };
                el.onmouseout = () => {
                    target.classList.remove(...["border", "border-red-500", "border-dotted"]);
                    el.classList.remove(...["border", "border-red-500", "border-dotted"]);
                };
            }
        }
    });
};

connectElements("div.connect", true);
connectElements("span.connect", false);