const markInstance = new Mark(document.querySelector("#textcontent"));
const url = new URL(window.location.href);
const urlParam = new URLSearchParams(url.search);
if (urlParam.get("mark")) {
	markInstance.mark(urlParam.get("mark"));
}
