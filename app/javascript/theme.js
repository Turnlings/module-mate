document.addEventListener("turbo:load", () => {
  const doc = document.documentElement;
  const toggleBtn = document.getElementById("theme-toggle");

  // Restore saved theme
  const savedTheme = localStorage.getItem("theme");
  if (savedTheme) doc.dataset.theme = savedTheme;

  // Add event listener
  toggleBtn.addEventListener("click", () => {
    const newTheme = doc.dataset.theme === "light" ? "dark" : "light";
    doc.dataset.theme = newTheme;
    localStorage.setItem("theme", newTheme);
  });
});