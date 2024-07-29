
    const manifestId = document.getElementById("mirador").getAttribute("data-manifest");
    const pathToManifest = `iiif_manifests/${manifestId}/manifest.json`;
    const  manifests = {
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
                "canvasIndex": 0,
                "thumbnailNavigationPosition": 'off'
            }
        ]
    });
