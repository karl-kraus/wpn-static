var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);
class WPNDetailView extends HTMLElement {
  constructor() {
    super(...arguments);
    __publicField(this, "updateDetailView", () => {
      var _a;
      if (window.location.hash) {
        const entityId = window.location.hash.replace("#", "");
        const detailElement = this.querySelector(`[id^='details_${entityId}']`);
        (_a = this.querySelector("[id^='details_']:not(.d-none)")) == null ? void 0 : _a.classList.add("d-none");
        detailElement == null ? void 0 : detailElement.classList.remove("d-none");
        const anchorElement = document.getElementById(entityId);
        if (anchorElement) {
          anchorElement.style.scrollMarginTop = `${String(document.getElementsByTagName("wpn-header")[0].clientHeight)}px`;
          anchorElement.scrollIntoView();
        }
        const popoverTriggerElement = detailElement == null ? void 0 : detailElement.querySelector("[data-bs-toggle='popover']");
        if (popoverTriggerElement) {
          console.log(popoverTriggerElement);
          new bootstrap.Popover(popoverTriggerElement, { placement: "left" });
        }
      }
    });
  }
  connectedCallback() {
    this.updateDetailView();
    window.addEventListener("hashchange", this.updateDetailView);
  }
  disconntedCallback() {
    window.removeEventListener("hashchange", this.updateDetailView);
  }
  attributeChangedCallback(name, oldValue, newValue) {
    console.log(name);
  }
}
customElements.define("wpn-detail-view", WPNDetailView);
