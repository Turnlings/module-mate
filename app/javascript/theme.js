document.addEventListener("turbo:load", () => {
  const doc = document.documentElement;
  const toggleBtn = document.getElementById("theme-toggle");

  // Restore saved theme
  const savedTheme = localStorage.getItem("theme");
  if (savedTheme) doc.dataset.theme = savedTheme;

  if (!toggleBtn) { return; }

  // Add event listener
  toggleBtn.addEventListener("click", () => {
    const newTheme = doc.dataset.theme === "light" ? "dark" : "light";
    doc.dataset.theme = newTheme;
    localStorage.setItem("theme", newTheme);

    // Change just the theme colours of chartkick charts
    Object.values(Chartkick.charts).forEach(chart => {
      const currentColors = chart.options.colors || [];
      const newColors = chartColors(); // 5 theme-specific colors

      // Overwrite only the first 5, keep the rest
      const mergedColors = [...newColors, ...currentColors.slice(newColors.length)];

      chart.updateData(
        chart.getData(),
        Object.assign({}, chart.options, { colors: mergedColors })
      );
    });
  });
});

document.addEventListener("turbo:load", () => {
  if (!window.Chartkick) return;

  Object.values(Chartkick.charts).forEach(chart => {
    const currentColors = chart.options.colors || [];
    const newColors = chartColors();
    const mergedColors = [...newColors, ...currentColors.slice(newColors.length)];
    chart.updateData(chart.getData(), Object.assign({}, chart.options, { colors: mergedColors }));
  });
});

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