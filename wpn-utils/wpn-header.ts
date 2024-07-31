class WPNHeader extends HTMLElement {

  resizeObserver = new ResizeObserver((entries) => {
    for (const entry of entries) {
        const mainElement = document.querySelector("main");
        if (mainElement) {
          mainElement.style.marginTop = `${String(entry.target.clientHeight)}px`;
        }
    }
  })
  
  
  
  resizeHandler = () =>{ 
    document.body.style.marginTop = `${String(this.clientHeight)})px`;  
  }
	
	connectedCallback() {
    this.resizeObserver.observe(this);
  }
  disconntedCallback() {
    this.resizeObserver.unobserve(this);
  }
}

customElements.define("wpn-header", WPNHeader);
