document.getElementById('dropdownMenuButton1')!.addEventListener('click', function() {
    const paginationPb = document.getElementById('pagination-pb');
    paginationPb!.classList.toggle('visually-hidden');
    const infocontentPb = document.getElementById('infocontent-pb');
    infocontentPb!.classList.toggle('visually-hidden');
});

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

function initializeView1() {
    facscolumnBtn!.addEventListener('click', function() {
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

        params.set('view', 'facs-only');
        myUrl.search = params.toString();
        window.history.pushState({}, '', myUrl);

        prevPageLink!.href = prevPageLink!.href.replace(/view=.+/, 'view=facs-only');
        nextPageLink!.href = nextPageLink!.href.replace(/view=.+/, 'view=facs-only');
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

        params.set('view', 'text-only');
        myUrl.search = params.toString();
        window.history.pushState({}, '', myUrl);

        prevPageLink!.href = prevPageLink!.href.replace(/view=.+/, 'view=text-only');
        nextPageLink!.href = nextPageLink!.href.replace(/view=.+/, 'view=text-only');
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

        prevPageLink!.href = prevPageLink!.href.replace(/view=.+/, 'view=all-columns');
        nextPageLink!.href = nextPageLink!.href.replace(/view=.+/, 'view=all-columns');
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

        prevPageLink!.href = prevPageLink!.href.replace(/view=.+/, 'view=vertical');
        nextPageLink!.href = nextPageLink!.href.replace(/view=.+/, 'view=vertical');
    });
}

// Initialize views basedon clicked button
initializeView1();
initializeView2();
initializeView3();
initializeView4();

document.addEventListener('DOMContentLoaded', () => {
    // Set initial view based on URL parameter
    const initialView = params.get('view');
    if (initialView === 'facs-only') {

        facscolumnBtn!.click();
        prevPageLink!.href = prevPageLink!.href.replace(/view=.+/, 'view=facs-only');
        nextPageLink!.href = nextPageLink!.href.replace(/view=.+/, 'view=facs-only');

    } else if (initialView === 'text-only') {

        textcolumnBtn!.click();
        prevPageLink!.href = prevPageLink!.href.replace(/view=.+/, 'view=text-only');
        nextPageLink!.href = nextPageLink!.href.replace(/view=.+/, 'view=text-only');

    } else if (initialView === 'vertical') {

        allcolumnRowBtn!.click();
        prevPageLink!.href = prevPageLink!.href.replace(/view=.+/, 'view=vertical');
        nextPageLink!.href = nextPageLink!.href.replace(/view=.+/, 'view=vertical');

    } else if (initialView === 'all-columns' || !initialView) {

        allcolumnBtn!.click();
        prevPageLink!.href = prevPageLink!.href.replace(/view=.+/, 'view=all-columns');
        nextPageLink!.href = nextPageLink!.href.replace(/view=.+/, 'view=all-columns');

    }
});