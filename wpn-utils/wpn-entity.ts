import type WPNTextView from "./wpn-text-view";

class WPNEntity extends HTMLElement {

  clickHandler = () =>{ 
    document.querySelector(`div[data-xmlid=${this.getAttribute("id") ?? ''}]`)?.classList.toggle("d-none");
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
