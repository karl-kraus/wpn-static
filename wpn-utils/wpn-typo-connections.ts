// Description: This script is used to connect elements in 
// left and right margin with their anchor in the text.

document.querySelector<HTMLElement>("#textcontent-pb")?.addEventListener("mouseover", (event) => {

    const color = "connection-color";
    
    const target = event.target as HTMLElement;

    const anchorData = target.dataset.anchor;

    if (!anchorData) {
        document.querySelectorAll<HTMLElement>(`.${color}`).forEach((el) => {

            el.classList.remove(color);

        });
    };

    const anchorDataList = anchorData ? anchorData.split(" ") : [];

    if (anchorDataList.length === 0) return;

    anchorDataList.forEach((data) => {

        // highlight anchor
        const anchorElements = document.querySelectorAll<HTMLElement>(`[data-anchor~="${data}"]`);

        if(anchorElements.length > 1) {

            target.classList.add(color);

            anchorElements.forEach((el) => {

                el.classList.add(color);
            
            });

        }

        const targetElements = document.querySelectorAll<HTMLElement>(`[data-target~="${data}"]`);
        if (targetElements.length > 0) {

            target.classList.add(color);

            targetElements.forEach((el) => {

                el.classList.add(color);

            });
        }

    });

    const targetDataList = target.dataset.target;
    const targetIds = targetDataList ? targetDataList.split(" ") : [];

    if (targetIds.length === 0) return;
    // highlight targets
    targetIds.forEach((targetId) => {

        const targetElements = document.querySelectorAll<HTMLElement>(`[data-anchor~="${targetId}"]`);

        targetElements.forEach((el) => {

            el.classList.add(color);

        });

    });

});
