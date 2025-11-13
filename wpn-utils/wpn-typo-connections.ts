// Description: This script is used to connect elements in 
// left and right margin with their anchor in the text.
const myurl = new URL(window.location.href);
const searchParams = new URLSearchParams(myurl.search);
const content = document.querySelector<HTMLElement>("#textcontent-pb")

searchParams.set("mode", "explore");
content?.addEventListener("mouseover", highlighting);

myurl.search = searchParams.toString();
window.history.pushState({}, '', myurl);

document.querySelector<HTMLElement>("#setMode")?.addEventListener("click", (event) => {
    const target = event.currentTarget as HTMLElement;
    target.classList.toggle("active-view-icon");

    if (target.classList.contains("active-view-icon")) {

        searchParams.set("mode", "inspect");
        content?.removeEventListener("mouseover", highlighting);
        content?.addEventListener("click", highlighting);

    } else {

        searchParams.set("mode", "explore");
        content?.removeEventListener("click", highlighting);
        content?.addEventListener("mouseover", highlighting);

    }

    myurl.search = searchParams.toString();
    window.history.pushState({}, '', myurl);
});


function highlighting(event: Event) {

    console.log("Mode: Explore connections between annotations and text. Loaded!");

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

            target.classList.remove(color);
            target.classList.add(color);

            anchorElements.forEach((el) => {

                el.classList.remove(color);
                el.classList.add(color);
            
            });

        }

        const targetElements = document.querySelectorAll<HTMLElement>(`[data-target~="${data}"]`);
        if (targetElements.length > 0) {

            target.classList.remove(color);
            target.classList.add(color);

            targetElements.forEach((el) => {

                el.classList.remove(color);
                el.classList.add(color);

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

            targetElements.forEach((el) => {

                el.classList.remove(color);
                el.classList.add(color);

            });
        }

    });

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