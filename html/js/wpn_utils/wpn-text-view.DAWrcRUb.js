var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);
class WPNTextView extends HTMLElement {
  constructor() {
    super(...arguments);
    __publicField(this, "calcMargin", (element, source_offset) => {
      let offset = source_offset;
      if (element.previousElementSibling)
        while (element = element.previousElementSibling) {
          if (!element.classList.contains("d-none")) {
            offset -= (parseInt(element.style.marginTop, 10) || 0) + element.offsetHeight;
          }
        }
      return Math.max(Math.min(offset, 0), offset, 0);
    });
  }
  positionElements(annotationSelectors) {
    console.log("repositioned");
    Array.from(document.querySelectorAll(annotationSelectors)).forEach((el) => {
      const element = el;
      const elmId = el.getAttribute("id") ?? "";
      let offset = element.offsetTop - document.getElementsByTagName("wpn-header")[0].offsetHeight;
      console.log(offset, el.getAttribute("id") ?? "");
      offset += parseInt(getComputedStyle(el).lineHeight, 10) / 2;
      let infoElm = document.querySelector(`div[data-xmlid=${elmId}]`);
      infoElm = document.querySelector(`div[data-xmlid=${elmId}]`);
      if (infoElm) {
        const calculatedMargin = this.calcMargin(infoElm, offset) - parseInt(getComputedStyle(el).lineHeight, 10) / 2;
        const margin = String(Math.max(Math.min(calculatedMargin, 0), calculatedMargin, 0));
        infoElm.style.marginTop = `${margin}px`;
      }
    });
  }
  connectedCallback() {
    const annotationSelectors = this.getAttribute("annotation-selectors") ?? "";
    this.positionElements(annotationSelectors);
    [...document.getElementsByTagName("annotation-slider")].forEach((aos) => {
      aos.addEventListener("click", () => {
        this.positionElements(".entity");
      });
    });
    this.addEventListener("stateChange", () => {
      console.log("state changed");
      this.positionElements(".entity");
    });
  }
}
customElements.define("wpn-text-view", WPNTextView);
