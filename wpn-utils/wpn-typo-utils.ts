import OpenSeadragon from "openseadragon";

// Toggle visibility of pagination and info content on dropdown button click
document.getElementById('dropdownMenuButton1')!.addEventListener('click', function() {
    const paginationPb = document.getElementById('pagination-pb');
    paginationPb!.classList.toggle('visually-hidden');
    paginationPb!.ariaExpanded = paginationPb!.classList.contains('visually-hidden') ? 'false' : 'true';
    const infocontentPb = document.getElementById('infocontent-pb');
    infocontentPb!.classList.toggle('visually-hidden');
});

const initializeDropdown = (button: string, content: string) => {
    const dropdownButton = document.getElementById(button) as HTMLButtonElement | null;
    const dropdownContent = document.getElementById(content) as HTMLDivElement | HTMLUListElement | null;

    if (dropdownButton && dropdownContent) {
        
        dropdownButton.addEventListener('click', function() {
            dropdownContent.classList.toggle('visually-hidden');
            dropdownButton.ariaExpanded = dropdownContent.classList.contains('visually-hidden') ? 'false' : 'true';
        });
    }
};

initializeDropdown('btn_general_info', 'list_general_info');
initializeDropdown('btn_carrier_info', 'list_carrier_info');
initializeDropdown('btn_more_text_layers', 'list_more_layers');
initializeDropdown('btn_tpq_info', 'list_tpq_info');
initializeDropdown('btn_delQP_info', 'list_delQP_info');


// View toggle buttons and content columns
const myUrl = new URL(window.location.href);
const params = new URLSearchParams(myUrl.search);

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

function initializeView1() {
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
        myUrl.search = params.toString();
        window.history.pushState({}, '', myUrl);

        updateLinksView('text-only');

    });
}

function initializeView2() {
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
        myUrl.search = params.toString();
        window.history.pushState({}, '', myUrl);

        updateLinksView('facs-only');

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
}

function initializeView3() {
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
        myUrl.search = params.toString();
        window.history.pushState({}, '', myUrl);

        updateLinksView('all-columns');

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
}

function initializeView4() {
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
        myUrl.search = params.toString();
        window.history.pushState({}, '', myUrl);
        updateLinksView('vertical');

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
}

function updateLinksView(view: string) {

    if (prevPageLink) {
        prevPageLink.href = prevPageLink.href.replace(/view=.+/, `view=${view}`);
    }

    if (nextPageLink) {
        nextPageLink.href = nextPageLink.href.replace(/view=.+/, `view=${view}`);
    }

    if (pagination) {
        pagination!.forEach((link) => {

        link.href = link.href.replace(/view=.+/, `view=${view}`);

        });
    }

}

// Initialize views basedon clicked button
initializeView1();
initializeView2();
initializeView3();
initializeView4();

document.addEventListener('DOMContentLoaded', () => {
    // Set initial view based on URL parameter
    const initialView = params.get('view');
    if (initialView === 'text-only') {

        facscolumnBtn!.click();
        updateLinksView('text-only');

    } else if (initialView === 'facs-only') {

        textcolumnBtn!.click();
        updateLinksView('facs-only');

    } else if (initialView === 'vertical') {

        allcolumnRowBtn!.click();
        updateLinksView('vertical');

    } else if (initialView === 'all-columns' || !initialView) {

        allcolumnBtn!.click();
        updateLinksView('all-columns');

    }
});