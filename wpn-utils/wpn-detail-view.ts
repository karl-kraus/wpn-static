class WPNDetailView extends HTMLElement {
  
  
  updateDetailView = () => {
    if(window.location.hash) {
      const entityId = window.location.hash.replace('#','');
      this.classList.remove('d-none');
      const detailElement = this.querySelector(`[id^='details_${entityId}']`);
      this.querySelector("[id^='details_']:not(.d-none)")?.classList.add('d-none');
      detailElement?.classList.remove("d-none");
      const anchorElement = document.getElementById(entityId);
      if (anchorElement) {
        anchorElement.style.scrollMarginTop = `${String(document.getElementsByTagName("wpn-header")[0].clientHeight)}px`
        anchorElement.scrollIntoView()
      }
      const popoverTriggerElement = detailElement?.querySelector("[data-bs-toggle='popover']")
      if (popoverTriggerElement) {
        new bootstrap.Popover(popoverTriggerElement, {placement:'left'})
      }
      if (detailElement) {
        detailElement.querySelector(".close-button")?.addEventListener("click", () => {
          this.classList.add('d-none');
          detailElement.classList.add('d-none');
        })
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
  }
}


customElements.define("wpn-detail-view", WPNDetailView);