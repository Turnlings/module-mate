document.addEventListener("turbo:load", () => {
  const doc = document.documentElement;
  const toggleBtns = document.querySelectorAll(".theme-toggle");

  // Restore saved theme
  const savedTheme = localStorage.getItem("theme");
  if (savedTheme) doc.dataset.theme = savedTheme;

  applyThemeToCharts();

  if (!toggleBtns.length) return;

  // Add event listener to all toggle buttons
  toggleBtns.forEach(toggleBtn => {
    // Prevent double-binding if Turbo restores from cache
    if (toggleBtn.dataset.themeBound === "true") return;
    toggleBtn.dataset.themeBound = "true";

    toggleBtn.addEventListener("click", () => {
      const newTheme = doc.dataset.theme === "light" ? "dark" : "light";
      doc.dataset.theme = newTheme;
      localStorage.setItem("theme", newTheme);

      applyThemeToCharts();
    });
  });
});

function applyThemeToCharts() {
  // Chartkick may not be loaded on all pages; don't throw.
  if (!window.Chartkick || !Chartkick.charts) return;

  const charts = Object.values(Chartkick.charts);
  if (!charts.length) return;

  const newColors = chartColors();

  charts.forEach(chart => {
    const currentColors = (chart.options && chart.options.colors) || [];
    const mergedColors = [...newColors, ...currentColors.slice(newColors.length)];

    chart.updateData(
      chart.getData(),
      Object.assign({}, chart.options, { colors: mergedColors })
    );
  });
}

// Helper function for getting all the chart colours that fit the theme
function chartColors() {
  const styles = getComputedStyle(document.documentElement);
  const colors = [];
  for (let i = 1; i <= 5; i++) {
    const val = styles.getPropertyValue(`--chart-color-${i}`).trim();
    if (val) colors.push(val);
  }
  return colors;
}