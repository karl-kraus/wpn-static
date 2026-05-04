const currentURL = new URL(window.location.href);

let canvasLabel = null;
if (currentURL.searchParams.has("canvas")) {
  canvasLabel = currentURL.searchParams.get("canvas");
}

const manifestId = document.getElementById("mirador")?.getAttribute("data-manifest");
const pathToManifest = `iiif_manifests/${manifestId}/manifest.json`;

const manifests = {
  [pathToManifest]: {
    provider: "Karl Kraus 1933"
  }
};

function getCanvasLabel(canvas) {
  if (canvas.label) {
    if (typeof canvas.label === "string") return canvas.label;
    if (Array.isArray(canvas.label)) return canvas.label[0];
    if (canvas.label.en) return canvas.label.en[0];
  }
  return canvas.id || canvas["@id"];
}

function findCanvasIndexByLabel(manifest, label) {
  const canvases = manifest.sequences?.[0]?.canvases || [];
  return canvases.findIndex(c => getCanvasLabel(c) === label);
}

(async function initMirador() {
  const manifestRes = await fetch(pathToManifest);
  const manifestJson = await manifestRes.json();

  let canvasIndex = 0;

  if (canvasLabel) {
    const foundIndex = findCanvasIndexByLabel(manifestJson, canvasLabel);
    if (foundIndex !== -1) {
      canvasIndex = foundIndex;
    }
  }

  const mirador = Mirador.viewer({
    id: "mirador",
    manifests,
    themes: {
      light: {
        palette: {
          type: "light",
          primary: {
            main: "#A21A17"
          }
        }
      }
    },
    language: "de",
    displayAllAnnotations: false,
    window: {
      allowClose: false,
      allowFullscreen: false,
      allowMaximize: false,
      allowTopMenuButton: true,
      hideWindowTitle: false,
      defaultSideBarPanel: "annotations",
      sideBarOpenByDefault: true,
      panels: {
        info: false,
        attribution: false,
        canvas: false,
        annotations: true,
        search: true
      }
    },
    workspaceControlPanel: {
      enabled: false
    },
    galleryView: {
      height: null,
      width: 50
    },
    thumbnailNavigation: {
      defaultPosition: "off",
      height: 200
    },
    windows: [
      {
        loadedManifest: pathToManifest,
        canvasIndex,
        thumbnailNavigationPosition: "off",
        view: "single"
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

    const canvas = canvases.find(
      c => (c.id || c["@id"]) === win.canvasId
    );
    if (!canvas) return;

    const label = getCanvasLabel(canvas);

    const newUrl = new URL(window.location);
    newUrl.searchParams.set("canvas", label);
    history.replaceState({}, "", newUrl);
  });
})();