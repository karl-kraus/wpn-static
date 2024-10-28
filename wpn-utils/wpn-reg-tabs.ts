const urlSearchParams = new URLSearchParams(window.location.search);
if (urlSearchParams.has("letter")) {
  const regLetter = urlSearchParams.get("letter");
  if (regLetter) {
    const triggerEl = document.querySelector(`a[data-bs-target='#${regLetter}-pane']`);
    if (triggerEl) {
      const tab = bootstrap.Tab.getOrCreateInstance(triggerEl);
      tab.show();
    }
  }
}