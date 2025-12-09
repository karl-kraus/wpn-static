import OpenSeadragon from "openseadragon";

const myUrl = new URL(window.location.href);
const params = new URLSearchParams(myUrl.search);
// Toggle visibility of pagination and info content on dropdown button click
const paginationButton = document.querySelector('#dropdownMenuButton1') as HTMLElement | null;
// Toggle visibility of legende on legende button click
const legendBtn = document.getElementById('legende-btn');
// Toggle visibility of info content column on hide button click
const hideBtn = document.getElementById('infocontent-hide-btn')

// check if #setMode button state changes
const setModeButton = document.getElementById("setMode") as HTMLButtonElement | null;


paginationButton!.addEventListener('click', function() {

    const paginationPb = document.getElementById('pagination-pb');
    paginationPb!.classList.toggle('visually-hidden');
    paginationPb!.ariaExpanded = paginationPb!.classList.contains('visually-hidden') ? 'false' : 'true';

    const infocontentPb = document.getElementById('infocontent-pb');
    infocontentPb!.classList.toggle('visually-hidden');

});

legendBtn!.addEventListener('click', function() {

    legendBtn!.classList.toggle('active');
    legendBtn!.ariaExpanded = legendBtn!.classList.contains('active') ? 'true' : 'false';
    legendBtn!.setAttribute('title', legendBtn!.classList.contains('active') ? 'Legende schließen' : 'Legende öffnen');
    legendBtn!.parentElement!.classList.toggle('bg-primary');
    legendBtn!.parentElement!.classList.toggle('text-white');

    const legendePb = document.getElementById('legende-pb');
    legendePb!.classList.toggle('visually-hidden');
    legendePb!.ariaExpanded = legendePb!.classList.contains('visually-hidden') ? 'false' : 'true';
    
    const infocontentPb = document.getElementById('infocontent-pb');
    infocontentPb!.classList.toggle('visually-hidden');

});

hideBtn!.addEventListener('click', function() {
    hideBtn!.classList.toggle('active');

    const grid = document.getElementById('sub_grid_pb');
    grid!.classList.toggle('hide_btn');

    const infocontent = document.querySelector('#infocontent-wrapper');
    infocontent!.classList.toggle('visually-hidden');

    const infocontentHideIcon = document.getElementById('infocontent-hide-icon');
    infocontentHideIcon!.classList.toggle('visually-hidden');

    const infocontentHideIconHidden = document.getElementById('infocontent-hide-icon-hidden');
    infocontentHideIconHidden!.classList.toggle('visually-hidden');

    if (infocontent!.classList.contains('visually-hidden')) {

        hideBtn!.setAttribute('title', 'Info-Spalte öffnen');

        const infoHeader = document.getElementById('infocontent-header');
        infoHeader!.classList.remove('flex-row');
        infoHeader!.classList.add('flex-column');

        const paginationDropdown = document.getElementById('paginationLabel');
        paginationDropdown!.classList.add('visually-hidden');

        const paginationButton = document.querySelector('#dropdownMenuButton1 span') as HTMLElement | null;
        // change text to vertical
        paginationButton!.classList.add('visually-hidden');

    } else {

        hideBtn!.setAttribute('title', 'Info-Spalte schließen');

        const infoHeader = document.getElementById('infocontent-header');
        infoHeader!.classList.remove('flex-column');
        infoHeader!.classList.add('flex-row');

        const paginationDropdown = document.getElementById('paginationLabel');
        paginationDropdown!.classList.remove('visually-hidden');

        const paginationButton = document.querySelector('#dropdownMenuButton1 span') as HTMLElement | null;
        paginationButton!.classList.remove('visually-hidden');

    }

    if (infocontent!.classList.contains('visually-hidden')) {
        params.set('info', 'hidden');
    } else {
        params.delete('info');
    }

    updateLinksView(params.get('view') ?? "all-columns", params.get('info') ?? undefined);

    myUrl.search = params.toString();
    window.history.pushState({}, '', myUrl);

});

// Dropdown buttons and content lists

const initializeDropdown = (button: string, content: string, all_elements: Array<string>) => {

    const dropdownButton = document.getElementById(button) as HTMLButtonElement | null;
    const dropdownContent = document.getElementById(content) as HTMLDivElement | HTMLUListElement | null;

    if (dropdownButton && dropdownContent) {
        
        dropdownButton.addEventListener('click', function() {

            all_elements = all_elements.filter(el => el !== button && el !== content);

            all_elements.forEach((el) => {
                const elElement = document.getElementById(el);
                console.log(el, elElement);

                if (elElement) {
                    if (el.includes("btn_")) {
                        elElement!.classList.remove('active');
                    } else {
                        elElement!.classList.add('visually-hidden');
                    }
                }
            });

            dropdownContent.classList.toggle('visually-hidden');
            dropdownButton.ariaExpanded = dropdownContent.classList.contains('visually-hidden') ? 'false' : 'true';
        });
    }
};

const allDropdowns = [
    'btn_general_info',
    'list_general_info',
    'btn_carrier_info',
    'list_carrier_info',
    'btn_more_text_layers',
    'list_more_layers',
    'btn_tpq_info',
    'list_tpq_info',
    'btn_delQP_info',
    'list_delQP_info'
];

initializeDropdown('btn_general_info', 'list_general_info', allDropdowns);
initializeDropdown('btn_carrier_info', 'list_carrier_info', allDropdowns);
initializeDropdown('btn_more_text_layers', 'list_more_layers', allDropdowns);
initializeDropdown('btn_tpq_info', 'list_tpq_info', allDropdowns);
initializeDropdown('btn_delQP_info', 'list_delQP_info', allDropdowns);
initializeDropdown('btn-corresp-fackel', 'corresp-fackel-list', []);
initializeDropdown('btn-corresp-printInstruction', 'corresp-printInstruction-list', []);
initializeDropdown('btn-corresp-overwritten', 'list-corresp-overwritten', []);

// View toggle buttons and content columns
const allcolumnBtn = document.getElementById('allcolumnBtn') as HTMLDivElement | null;
const facscolumnBtn = document.getElementById('facscolumnBtn') as HTMLDivElement | null;
const textcolumnBtn = document.getElementById('textcolumnBtn') as HTMLDivElement | null;
const allcolumnRowBtn = document.getElementById('allcolumnRowBtn') as HTMLDivElement | null;

const grid = document.getElementById('sub_grid_pb') as HTMLDivElement | null;
const textcolumn = document.getElementById('textcolumn-pb') as HTMLDivElement | null;
const facscolumn = document.getElementById('facscolumn') as HTMLDivElement | null;

const prevPageLink = document.getElementById('prevPageLink') as HTMLAnchorElement | null;
const nextPageLink = document.getElementById('nextPageLink') as HTMLAnchorElement | null;
const pagination = document.querySelectorAll('#pagination-pb div a') as NodeListOf<HTMLAnchorElement> | null;

// const sub_grid_pb = document.getElementById('sub_grid_pb');
const facscontent: HTMLElement | null = document.getElementById("facscontent") ?? null;

facscolumnBtn!.addEventListener('click', function() {

    if (!facscontent) {
        throw new Error("No facscontent element found");
    } else {
        facscontent.innerHTML = "";
    }
        
    allcolumnBtn!.classList.remove('active-view-icon');
    facscolumnBtn!.classList.add('active-view-icon');
    if (allcolumnRowBtn!.classList.contains('active-view-icon')) {
        allcolumnRowBtn!.classList.remove('active-view-icon');
    }
    if (textcolumnBtn!.classList.contains('active-view-icon')) {
        textcolumnBtn!.classList.remove('active-view-icon');
        textcolumn!.classList.remove('visually-hidden');
    }
    facscolumn!.classList.add('visually-hidden');
    grid!.classList.remove('sub_grid_pb_three');
    grid!.classList.remove('sub_grid_pb_vertical');
    grid!.classList.add('sub_grid_pb_two');

    params.set('view', 'text-only');
    updateLinksView('text-only', params.get('info') ?? undefined);
    myUrl.search = params.toString();
    window.history.pushState({}, '', myUrl);


});

textcolumnBtn!.addEventListener('click', function() {

    allcolumnBtn!.classList.remove('active-view-icon');
    textcolumnBtn!.classList.add('active-view-icon');
    if (allcolumnRowBtn!.classList.contains('active-view-icon')) {
        allcolumnRowBtn!.classList.remove('active-view-icon');
    }
    if (facscolumnBtn!.classList.contains('active-view-icon')) {
        facscolumnBtn!.classList.remove('active-view-icon');
        facscolumn!.classList.remove('visually-hidden');
    }
    textcolumn!.classList.add('visually-hidden');
    grid!.classList.remove('sub_grid_pb_three');
    grid!.classList.remove('sub_grid_pb_vertical');
    grid!.classList.add('sub_grid_pb_two');

    params.set('view', 'facs-only');
    updateLinksView('facs-only', params.get('info') ?? undefined);
    myUrl.search = params.toString();
    window.history.pushState({}, '', myUrl);


    if (!facscontent) {
        throw new Error("No facscontent element found");
    } else {
        facscontent.innerHTML = "";
    }

    const height = facscolumn?.clientHeight;
    const width = facscolumn?.clientWidth;
    facscontent.style.height = height! - 20 + "px";
    facscontent.style.width = width! - 20 + "px";
    facscontent.style.cursor = "grab";
    const image = facscontent.getAttribute("wpn-data") ?? "";

    const imageUrl = {
        type: "image",
        url: `https://iiif.acdh.oeaw.ac.at/${image}.jp2/full/max/0/default.jpg`
    }
    const viewer = OpenSeadragon({
        id: "facscontent",
        tileSources: imageUrl,
        prefixUrl: 'https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.1/images/',
        maxZoomLevel: 10,
    });

    viewer.addHandler('open', function() {

        var tiledImage = viewer.world.getItemAt(0); 

        var imageRect = new OpenSeadragon.Rect(0, 0, width , height); 

        var viewportRect = tiledImage.imageToViewportRectangle(imageRect);
        viewer.viewport.fitBounds(viewportRect, true);

    });

});

allcolumnBtn!.addEventListener('click', function() {

    allcolumnBtn!.classList.add('active-view-icon');
    if (facscolumnBtn!.classList.contains('active-view-icon')) {
        facscolumnBtn!.classList.remove('active-view-icon');
        facscolumn!.classList.remove('visually-hidden');
    }
    if (textcolumnBtn!.classList.contains('active-view-icon')) {
        textcolumnBtn!.classList.remove('active-view-icon');
        textcolumn!.classList.remove('visually-hidden');
    }
    if (allcolumnRowBtn!.classList.contains('active-view-icon')) {
        allcolumnRowBtn!.classList.remove('active-view-icon');
    }
    grid!.classList.remove('sub_grid_pb_two');
    grid!.classList.remove('sub_grid_pb_vertical');
    grid!.classList.add('sub_grid_pb_three');

    params.set('view', 'all-columns');
    updateLinksView('all-columns', params.get('info') ?? undefined);
    myUrl.search = params.toString();
    window.history.pushState({}, '', myUrl);

    if (!facscontent) {
        throw new Error("No facscontent element found");
    } else {
        facscontent.innerHTML = "";
    }

    const type = facscontent.getAttribute("wpn-type") ?? "";
    facscontent.style.height = type === "witnessPrint" ? "21cm" : "26cm";
    facscontent.style.width = type === "witnessPrint" ? "14.2cm" : "19.4cm";
    facscontent.style.cursor = "grab";
    const image = facscontent.getAttribute("wpn-data") ?? "";

    const imageUrl = {
        type: "image",
        url: `https://iiif.acdh.oeaw.ac.at/${image}.jp2/full/max/0/default.jpg`
    }
    OpenSeadragon({
        id: "facscontent",
        tileSources: imageUrl,
        prefixUrl: 'https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.1/images/',
        maxZoomLevel: 10,
    });

});

allcolumnRowBtn!.addEventListener('click', function() {

    allcolumnRowBtn!.classList.add('active-view-icon');
    if (facscolumnBtn!.classList.contains('active-view-icon')) {
        facscolumnBtn!.classList.remove('active-view-icon');
        facscolumn!.classList.remove('visually-hidden');
    }
    if (textcolumnBtn!.classList.contains('active-view-icon')) {
        textcolumnBtn!.classList.remove('active-view-icon');
        textcolumn!.classList.remove('visually-hidden');
    }
    if (allcolumnBtn!.classList.contains('active-view-icon')) {
        allcolumnBtn!.classList.remove('active-view-icon');
    }
    grid!.classList.remove('sub_grid_pb_two');
    grid!.classList.remove('sub_grid_pb_three');
    grid!.classList.add('sub_grid_pb_vertical');

    params.set('view', 'vertical');
    updateLinksView('vertical', params.get('info') ?? undefined);
    myUrl.search = params.toString();
    window.history.pushState({}, '', myUrl);

    if (!facscontent) {
        throw new Error("No facscontent element found");
    } else {
        facscontent.innerHTML = "";
    }

    const height = facscolumn?.clientHeight;
    const width = facscolumn?.clientWidth;
    facscontent.style.height = height! - 20 + "px";
    facscontent.style.width = width! - 20 + "px";
    facscontent.style.cursor = "grab";
    const image = facscontent.getAttribute("wpn-data") ?? "";

    const imageUrl = {
        type: "image",
        url: `https://iiif.acdh.oeaw.ac.at/${image}.jp2/full/max/0/default.jpg`
    }
    const viewer = OpenSeadragon({
        id: "facscontent",
        tileSources: imageUrl,
        prefixUrl: 'https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.1/images/',
        maxZoomLevel: 10,
    });

    viewer.addHandler('open', function() {
        var tiledImage = viewer.world.getItemAt(0); 

        var imageRect = new OpenSeadragon.Rect(0, 0, width , height);

        var viewportRect = tiledImage.imageToViewportRectangle(imageRect);
        viewer.viewport.fitBounds(viewportRect, true);
        
    });

});

function updateLinksView(view: string, info?: string, mode?: string) {

    if (prevPageLink) {
        const prevUrl = new URL(prevPageLink.href);
        const prevParams = prevUrl.searchParams;
        prevParams.set('view', view);
        prevParams.set('info', info ?? '');
        prevParams.set('mode', mode ?? 'off');
        prevUrl.search = prevParams.toString();
        prevPageLink.href = prevUrl.toString();
    }

    if (nextPageLink) {
        const nextUrl = new URL(nextPageLink.href);
        const nextParams = nextUrl.searchParams;
        nextParams.set('view', view);
        nextParams.set('info', info ?? '');
        nextParams.set('mode', mode ?? 'off');
        nextUrl.search = nextParams.toString();
        nextPageLink.href = nextUrl.toString();
    }

    if (pagination) {
        pagination!.forEach((link) => {

            const mylink = new URL(link.href);
            const myparams = mylink.searchParams;
            myparams.set('view', view);
            myparams.set('info', info ?? '');
            myparams.set('mode', mode ?? 'off');
            mylink.search = myparams.toString();
            link.href = mylink.toString();

        });
    }

}

document.addEventListener('DOMContentLoaded', () => {

    // Set initial view based on URL parameter
    const initialView = params.get('view');
    const hideInfo = params.get('info');
    const mode = params.get('mode');

    if (initialView === 'text-only') {

        facscolumnBtn!.click();

    } else if (initialView === 'facs-only') {

        textcolumnBtn!.click();

    } else if (initialView === 'vertical') {

        allcolumnRowBtn!.click();

    } else if (initialView === 'all-columns' || !initialView) {

        allcolumnBtn!.click();
    }

    if (hideInfo === 'hidden') {
        hideBtn!.click();
    }

    updateLinksView(initialView ?? 'all-columns', hideInfo ?? undefined, mode ?? undefined);

    setModeButton?.addEventListener("click", () => {
        const myUrl = new URL(window.location.href);
        const params = new URLSearchParams(myUrl.search);
        const initialView = params.get('view');
        const hideInfo = params.get('info');
        const mode = params.get('mode');
        updateLinksView(initialView ?? 'all-columns', hideInfo ?? undefined, mode ?? undefined);
    });

});