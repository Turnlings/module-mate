// TODO: come up with a more robust approach that isnt so janky.
// Close the sidebar offcanvas when opening a Turbo-frame modal.
// Using data-bs-dismiss on the link can prevent Turbo from completing the frame request.
// This approach waits for the click, starts the Turbo visit, then hides the offcanvas.

import Offcanvas from "bootstrap/js/dist/offcanvas";

function cleanupOffcanvasArtifacts() {
  // Sometimes Bootstrap leaves a backdrop around if the offcanvas is hidden while
  // Turbo is swapping DOM. Clean up any leftovers.
  document.querySelectorAll('.offcanvas-backdrop').forEach((b) => b.remove());
  document.body.classList.remove('offcanvas-backdrop');
  document.body.classList.remove('modal-open');
  document.body.style.removeProperty('overflow');
  document.body.style.removeProperty('padding-right');
}

function hideSidebarOffcanvasIfOpen() {
  const el = document.getElementById("sidebarOffcanvas");
  if (!el) return;

  const instance = Offcanvas.getInstance(el) || Offcanvas.getOrCreateInstance(el);
  // Only hide if it's currently shown
  if (el.classList.contains("show")) instance.hide();

  // Always attempt cleanup (no-op if nothing is stuck)
  cleanupOffcanvasArtifacts();
}

function isModalFrameLink(target) {
  const a = target.closest && target.closest("a");
  if (!a) return false;
  return a.dataset.turboFrame === "modal";
}

document.addEventListener("turbo:load", () => {
  document.addEventListener("click", (e) => {
    if (!isModalFrameLink(e.target)) return;

    // Hide offcanvas immediately so the backdrop doesn't linger over the modal.
    hideSidebarOffcanvasIfOpen();

    // Also do a delayed cleanup in case Bootstrap adds the backdrop on the same tick.
    setTimeout(cleanupOffcanvasArtifacts, 50);
  });
});

// When the modal frame finishes loading, ensure no offcanvas backdrop is still present.
document.addEventListener('turbo:frame-load', (e) => {
  if (e.target && e.target.id === 'modal') cleanupOffcanvasArtifacts();
});
