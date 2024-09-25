import type WPNTextView from "./wpn-text-view";

class WPNEntity extends HTMLElement {

  clickHandler = () =>{ 
    const targetId = this.hasAttribute("data-prev") ? this.getAttribute("data-prev") : this.getAttribute("id");
    const annotationClassName = Array.from(this.classList).find(className => className.startsWith("annot_"));
    if (annotationClassName) {
      if (document.querySelector(`annotation-slider .${annotationClassName}`)) {
        Array.from(document.querySelectorAll(`div[data-xmlid=${targetId ?? ''}]`)).forEach((el)=> el.classList.toggle("d-none"));
      }
    }
    this.notifyTextView();
    
  }
	
	connectedCallback() {
    this.addEventListener("click", this.clickHandler)
  }
  disconntedCallback() {
    this.removeEventListener("click",this.clickHandler)
  }
  notifyTextView = () => {
    this.dispatchEvent(new Event('stateChange',{ bubbles: true,}));
  }
}

customElements.define("wpn-entity", WPNEntity);
