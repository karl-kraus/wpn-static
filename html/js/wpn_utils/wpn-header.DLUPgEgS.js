var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);
class WPNHeader extends HTMLElement {
  constructor() {
    super(...arguments);
    __publicField(this, "resizeObserver", new ResizeObserver((entries) => {
      for (const entry of entries) {
        const mainElement = document.querySelector("main");
        const wpnDetailView = document.querySelector("wpn-detail-view");
        const footer = document.querySelector("footer");
        if (mainElement) {
          mainElement.style.marginTop = `${String(entry.target.clientHeight)}px`;
        }
        if (wpnDetailView) {
          wpnDetailView.style.top = `${String(entry.target.clientHeight)}px`;
          if (footer) {
            wpnDetailView.style.maxHeight = `calc(100% - ${String(entry.target.clientHeight + footer.clientHeight)}px`;
          }
        }
      }
    }));
  }
  connectedCallback() {
    this.resizeObserver.observe(this);
  }
  disconntedCallback() {
    this.resizeObserver.unobserve(this);
  }
}
customElements.define("wpn-header", WPNHeader);
