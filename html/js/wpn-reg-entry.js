var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);
class WPNRegEntry extends HTMLDivElement {
  constructor() {
    super(...arguments);
    __publicField(this, "clickHandler", () => {
      this.notifyDetailView();
    });
    __publicField(this, "notifyDetailView", () => {
      console.log(this.getAttribute("id"));
      this.dispatchEvent(new CustomEvent("updateDetailView", { bubbles: true, detail: { id: this.getAttribute("id") } }));
    });
  }
  connectedCallback() {
    this.addEventListener("click", this.clickHandler);
  }
  disconntedCallback() {
    this.removeEventListener("click", this.clickHandler);
  }
}
customElements.define("wpn-reg-entry", WPNRegEntry, { extends: "div" });
