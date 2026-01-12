// TODO: come up with a more robust approach that isnt so janky.
// Close the sidebar offcanvas when opening a Turbo-frame modal.
// Using data-bs-dismiss on the link can prevent Turbo from completing the frame request.
// This approach waits for the click, starts the Turbo visit, then hides the offcanvas.

import Offcanvas from "bootstrap/js/dist/offcanvas";

function hideSidebarOffcanvasIfOpen() {
  const el = document.getElementById("sidebarOffcanvas");
  if (!el) return;

  const instance = Offcanvas.getInstance(el) || Offcanvas.getOrCreateInstance(el);
  // Only hide if it's currently shown
  if (el.classList.contains("show")) instance.hide();
}

function isModalFrameLink(target) {
  const a = target.closest && target.closest("a");
  if (!a) return false;
  return a.dataset.turboFrame === "modal";
}

document.addEventListener("turbo:load", () => {
  document.addEventListener("click", (e) => {
    if (!isModalFrameLink(e.target)) return;

    // Let Turbo handle the click; then hide offcanvas so the backdrop doesn't block the modal.
    // setTimeout ensures this runs after Turbo has initiated the request.
    setTimeout(hideSidebarOffcanvasIfOpen, 0);
  });
});
