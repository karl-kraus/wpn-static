class WPNEntity extends HTMLElement {

  constructor() {
    super();
    this.tabIndex = 0;
    this.setAttribute('role', 'button');
  }

  get shouldBubble(): boolean {
    const attributeValue = this.getAttribute("bubble");
    
		return attributeValue === 'false' ? false : true;
	}

  clickHandler = (e: MouseEvent) =>{
    history.replaceState(null, '', window.location.pathname + window.location.search);
    const targetId = this.hasAttribute("data-prev") ? this.getAttribute("data-prev") : this.getAttribute("id");
    const annotationClassName = Array.from(this.classList).find(className => className.startsWith("annot_"));
    const annotationActiveClassName = `${annotationClassName}_active`;
    if (annotationClassName) {
      if (document.querySelector(`annotation-slider .${annotationClassName}`)) {
        document.querySelectorAll("wpn-entity[class*='_active']").forEach(el=>{
          const annotationActiveClassName = [...el.classList].find(cn => cn.endsWith("_active"));
          const annotationClassName = annotationActiveClassName?.replace("_active","");
          if (annotationActiveClassName && annotationClassName) {
            el.classList.replace(annotationActiveClassName,annotationClassName);
          }
        })
        this.classList.replace(annotationClassName, annotationActiveClassName);
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

  keyDownHandler = (e: KeyboardEvent) => {
     if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        this.click();
      }
  }
	
	connectedCallback() {
    this.addEventListener("click", this.clickHandler);
    this.addEventListener('keydown', this.keyDownHandler);
  }
  disconntedCallback() {
    this.removeEventListener("click",this.clickHandler);
    this.removeEventListener("keydown",this.keyDownHandler);
  }
  notifyTextView = () => {
    this.dispatchEvent(new Event('stateChange',{ bubbles: true}));
  }
}

customElements.define("wpn-entity", WPNEntity);
