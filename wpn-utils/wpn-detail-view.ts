class WPNDetailView extends HTMLDivElement {
  
  
  updateDetailView = () => {
    if(window.location.hash) {
      const entityId = window.location.hash.replace('#','');
      const detailElement = this.querySelector(`[id^='details_${entityId}']`);
      this.querySelector("[id^='details_']:not(.d-none)")?.classList.add('d-none');
      detailElement?.classList.remove("d-none");
      const popoverTriggerElement = detailElement?.querySelector("[data-bs-toggle='popover']")
      if (popoverTriggerElement) {
        console.log(popoverTriggerElement)
        new bootstrap.Popover(popoverTriggerElement, {placement:'left'})
      }
    }
  }
  
  connectedCallback() {
    
    this.updateDetailView();
    window.addEventListener("hashchange", this.updateDetailView)
  }
  disconntedCallback() {
    window.removeEventListener("hashchange", this.updateDetailView)
  }

  attributeChangedCallback(name, oldValue, newValue) {
    console.log(name)
  }
}


customElements.define("wpn-detail-view", WPNDetailView, { extends: "div" });