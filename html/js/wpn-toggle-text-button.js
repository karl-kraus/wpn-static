var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);
class WPNToggleTextButton extends HTMLAnchorElement {
  constructor() {
    super(...arguments);
    __publicField(this, "toggleClass", "wpn-expand");
    __publicField(this, "toggleText", "Expand Text");
  }
  getToggleTarget(targetElementId) {
    const targetElement = document.getElementById(targetElementId);
    return targetElement;
  }
  connectedCallback() {
    const text = this.innerHTML;
    this.onclick = (e) => {
      e.preventDefault();
      const targetElementId = this.getAttribute("target-element") ?? "";
      const target_element = this.getToggleTarget(targetElementId);
      if (target_element) {
        target_element.classList.toggle(this.toggleClass);
        if (target_element.classList.contains(this.toggleClass)) {
          this.innerText = this.getAttribute("toggle-text") ?? this.toggleText;
        } else {
          this.innerText = text;
        }
      }
    };
  }
}
customElements.define("wpn-toggle-text-button", WPNToggleTextButton, { extends: "a" });
