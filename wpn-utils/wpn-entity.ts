class WPNEntity extends HTMLElement {
  get shouldBubble(): boolean {
    const attributeValue = this.getAttribute("bubble");
    
		return attributeValue === 'false' ? false : true;
	}

  clickHandler = (e: MouseEvent) =>{
    window.location.hash = "";
    const targetId = this.hasAttribute("data-prev") ? this.getAttribute("data-prev") : this.getAttribute("id");
    const annotationClassName = Array.from(this.classList).find(className => className.startsWith("annot_"));
    if (annotationClassName) {
      if (document.querySelector(`annotation-slider .${annotationClassName}`)) {
        Array.from(document.querySelectorAll(`div[data-xmlid=${targetId ?? ''}]`)).forEach((el)=> {
          if (el.classList.contains("d-none")) {
            el.classList.remove("d-none");
          }
        });
      }
    }
    if (!this.shouldBubble) {
      e.stopPropagation();
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
    this.dispatchEvent(new Event('stateChange',{ bubbles: true}));
  }
}

customElements.define("wpn-entity", WPNEntity);
