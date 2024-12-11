class WPNDetailView extends HTMLElement {
  
  
  updateDetailView = () => {
    if(window.location.hash) {
      const entityId = window.location.hash.replace('#','');
      this.classList.remove('d-none');
      const detailElement = this.querySelector(`[id='details_${entityId}']`);
      this.querySelector("[id^='details_']:not(.d-none)")?.classList.add('d-none');
      detailElement?.classList.remove("d-none");
      const anchorElement = document.getElementById(entityId);
      if (anchorElement) {
        anchorElement.style.scrollMarginTop = `${String(document.getElementsByTagName("wpn-header")[0].clientHeight)}px`
        anchorElement.scrollIntoView()
      }
      const popoverTriggerElements = detailElement?.querySelectorAll("[data-bs-toggle='popover']");
      popoverTriggerElements?.forEach(pTE=>{
        new bootstrap.Popover(pTE, {placement:'left',html: true,});
        pTE.addEventListener('shown.bs.popover',() =>{
          const elementsToHighlight = pTE.getAttribute("data-highlight")?.split(',');
          elementsToHighlight?.forEach(eTH =>{
            const citedRangeElement = this.querySelector(`span[data-cited-range=${eTH}]`);
            citedRangeElement?.classList.add('bg-lighter-grey');
            citedRangeElement?.parentElement?.querySelector(`span[data-bibl-id]`)?.classList.add('bg-lighter-grey');
          });
        })
        pTE.addEventListener('hidden.bs.popover',() =>{
          const elementsToHighlight = pTE.getAttribute("data-highlight")?.split(',');
          elementsToHighlight?.forEach(eTH =>{
            const citedRangeElement = this.querySelector(`span[data-cited-range=${eTH}]`);
            citedRangeElement?.classList.remove('bg-lighter-grey');
            citedRangeElement?.parentElement?.querySelector(`span[data-bibl-id]`)?.classList.remove('bg-lighter-grey');
          });
        })
      })
      if (detailElement) {
        detailElement.querySelector(".close-button")?.addEventListener("click", () => {
          this.classList.add('d-none');
          detailElement.classList.add('d-none');
        })
      }
    } else {
      this.classList.add("d-none");
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