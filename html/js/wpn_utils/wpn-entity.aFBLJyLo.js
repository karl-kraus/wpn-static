var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);
class WPNEntity extends HTMLElement {
  constructor() {
    super(...arguments);
    __publicField(this, "clickHandler", () => {
      var _a;
      (_a = document.querySelector(`div[data-xmlid=${this.getAttribute("id") ?? ""}]`)) == null ? void 0 : _a.classList.toggle("d-none");
      this.notifyTextView();
    });
    __publicField(this, "notifyTextView", () => {
      this.dispatchEvent(new Event("stateChange", { bubbles: true }));
    });
  }
  connectedCallback() {
    this.addEventListener("click", this.clickHandler);
  }
  disconntedCallback() {
    this.removeEventListener("click", this.clickHandler);
  }
}
customElements.define("wpn-entity", WPNEntity);
