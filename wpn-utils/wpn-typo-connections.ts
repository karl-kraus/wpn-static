// Description: This script is used to connect elements in 
// left and right margin with their anchor in the text.

document.querySelector<HTMLElement>("#textcontent-pb")?.addEventListener("mouseover", (event) => {

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

    const targetIds = targetDataList ? targetDataList.split(" ") : [];
    // highlight targets
    targetIds.forEach((targetId) => {

        const targetElements = document.querySelectorAll<HTMLElement>(`[data-anchor~="${targetId}"]`);

        if(targetElements.length > 0) {

            target.classList.add(color);

            targetElements.forEach((el) => {

                el.classList.add(color);

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

});
