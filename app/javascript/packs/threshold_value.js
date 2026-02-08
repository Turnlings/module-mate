function setupThresholdToggle(root = document) {
  const typeSelect = root.getElementById?.("exam_type") || root.querySelector?.("#exam_type");
  const thresholdField = root.getElementById?.("exam_threshold") || root.querySelector?.("#exam_threshold");

  if (!typeSelect || !thresholdField) return;

  // Prefer hiding the field's wrapper (Bootstrap-ish), fallback to just the input
  const wrapper =
    thresholdField.closest(".field, .form-group, .mb-3, .input") ||
    thresholdField.parentElement;

  function toggleThreshold() {
    const isThreshold = typeSelect.value === "Threshold";

    thresholdField.disabled = !isThreshold;

    if (wrapper) wrapper.style.display = isThreshold ? "" : "none";

    if (!isThreshold) {
      // Reset to default when not used
      thresholdField.value = 70;
    }
  }

  toggleThreshold();

  // Prevent double-binding
  if (typeSelect.dataset.thresholdBound === "true") return;
  typeSelect.dataset.thresholdBound = "true";
  typeSelect.addEventListener("change", toggleThreshold);
}

// Full page loads
document.addEventListener("turbo:load", () => setupThresholdToggle(document));
document.addEventListener("DOMContentLoaded", () => setupThresholdToggle(document));

// Turbo frame loads (modal forms, partial updates)
document.addEventListener("turbo:frame-load", (e) => setupThresholdToggle(e.target));
document.addEventListener("turbo:render", () => setupThresholdToggle(document));