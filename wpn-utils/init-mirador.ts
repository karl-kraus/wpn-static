
const currentURL = new URL(window.location.href);
let canvasIndex = 0;
if (currentURL.search) {
    const params = new URLSearchParams(currentURL.search);
    if (params.has("canvas")) {
      canvasIndex = Number(params.get("canvas"));          
    };

}


const manifestId = document.getElementById("mirador")?.getAttribute("data-manifest");
const pathToManifest = `iiif_manifests/${manifestId}/manifest.json`;


const manifests = {
    pathToManifest:
    {
        "provider": "Karl Kraus 1933"
    }
};

const mirador = Mirador.viewer({
    "id": "mirador",
    "manifests": manifests,
    "themes": {
        "light": {
            "palette": {
                "type": 'light',
                "primary": {
                    "main": '#A21A17'
                }
            }
        }
    },
    "language": "de",
    "displayAllAnnotations": false,
    "window": {
        "allowClose": false,
        "allowFullscreen": false,
        "allowMaximize": false,
        "allowTopMenuButton": true,
        "hideWindowTitle": false,
        "defaultSideBarPanel": 'annotations',
        "sideBarOpenByDefault": true,
        "panels": {
            "info": false,
            "attribution": false,
            "canvas": false,
            "annotations": true,
            "search": true
        }
    },
    "workspaceControlPanel": {
        "enabled": false, // Configure if the control panel should be rendered.  Useful if you want to lock the viewer down to only the configured manifests
    },

    "galleryView": {
        height: null,
        width: 50
    },

    "thumbnailNavigation": {
        defaultPosition: 'off', // Which position for the thumbnail navigation to be be displayed. Other possible values are "far-bottom" or "far-right"
        height: 200 // height of entire ThumbnailNavigation area when position is "far-bottom"
    },

    "windows": [
        {
            "loadedManifest": pathToManifest,
            "canvasIndex": canvasIndex - 1,
            "thumbnailNavigationPosition": 'off'
        }
    ]
});


const miradorStore = mirador.store;
let lastCanvasId = null;

miradorStore.subscribe(() => {
  const state = miradorStore.getState();
  
  const windowIds = Object.keys(state.windows);
  if (!windowIds.length) return;

  const win = state.windows[windowIds[0]];
  if (!win || win.canvasId === lastCanvasId) return;

  lastCanvasId = win.canvasId;

  const manifest = state.manifests[win.manifestId]?.json;
  if (!manifest) return;

  const canvases = manifest.sequences?.[0]?.canvases;
  if (!canvases) return;

  const index = canvases.findIndex(c => (c.id || c['@id']) === win.canvasId);
  if (index === -1) return;

  const newUrl = new URL(window.location);
  newUrl.searchParams.set("canvas", index + 1);
  history.replaceState({}, "", newUrl);
});