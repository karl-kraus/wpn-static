const contentElement = document.querySelector("#textcontent");
const headerElm = document.querySelector("wpn-header");
const markInstance = new Mark(contentElement);
const url = new URL(window.location.href);
const urlParam = new URLSearchParams(url.search);
const markValue = urlParam.get("mark");
const occurence = urlParam.get("occurence");
if (markValue) {
  markInstance.mark(markValue,{
    done: () => {
      const marks = contentElement.querySelectorAll("mark");
      let matchNr = 0;
      if (occurence && (/\d+/g).test(occurence)) {
          matchNr = Number(occurence) - 1;
        } 
        const position = marks[matchNr].offsetTop - headerElm.clientHeight;
        window.scrollTo(0, position);
      }
    })
  };
