const btn = document.getElementById("btn_more_text_layers");

btn?.addEventListener("click", () => {
    const dropdown = document.getElementById("list_more_text_layers");
    dropdown?.classList.toggle("fade");
});