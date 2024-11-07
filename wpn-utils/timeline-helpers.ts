const selectCategory = (event: Event) => {
  const timeline = document.querySelector("wpn-time-line");
  const inputElement = event.target as HTMLInputElement;
  if (timeline) {
    const timelineCategoriesAttribute = timeline.getAttribute("data-selected-categories");
    if (!timelineCategoriesAttribute) {
      return null;
    }
    let currentlySelectedCategories: unknown = JSON.parse(timelineCategoriesAttribute);
    let categoryToHighlight: string;

    if (Array.isArray(currentlySelectedCategories)) {
      if (inputElement.checked) {
        currentlySelectedCategories.push(inputElement.value);
        categoryToHighlight = inputElement.value;
      } else {
        currentlySelectedCategories = currentlySelectedCategories.filter(category=> category !== inputElement.value);
        categoryToHighlight = '';
      }
      timeline.setAttribute("data-selected-categories",JSON.stringify(currentlySelectedCategories));
      timeline.setAttribute("data-highlighted-category", categoryToHighlight);
    }
  } 
}

const changeHighlightedCategory = (event: Event) => {
  const timeline = document.querySelector("wpn-time-line");
  if (event.target) {
    const labelElement: HTMLLabelElement = (event.target as HTMLLabelElement);
    const relatedInput: HTMLInputElement = (labelElement.previousElementSibling as HTMLInputElement);
    if (event.type === 'mouseover') {
      if (relatedInput.checked) {
        timeline?.setAttribute("data-highlighted-category",relatedInput.value);
      }
    }
    else {
      {
        timeline?.setAttribute("data-highlighted-category",'');
      }
    }
  }
}

const timeLineInputs:Array<HTMLInputElement> = [...document.querySelectorAll<HTMLInputElement>(".timeline-helper")];

timeLineInputs.forEach((el:HTMLInputElement) => {
  el.addEventListener("change",selectCategory);
  el.labels?.item(0).addEventListener("mouseover", changeHighlightedCategory);
  el.labels?.item(0).addEventListener("mouseout", changeHighlightedCategory);
});
