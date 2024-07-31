class WPNRegEntry extends HTMLElement {

  clickHandler = () =>{ 
    this.notifyDetailView();
    
  }
	
	connectedCallback() {
    this.addEventListener("click", this.clickHandler)
  }
  disconntedCallback() {
    this.removeEventListener("click",this.clickHandler)
  }
  notifyDetailView = () => {
    console.log(this.getAttribute("id"))
    this.dispatchEvent(new CustomEvent('updateDetailView',{ bubbles: true,detail:{id:this.getAttribute("id")}}));
  }
}

customElements.define("wpn-reg-entry", WPNRegEntry);
