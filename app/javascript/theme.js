document.addEventListener("turbo:load", () => {
  const body = document.body;
  const toggleBtn = document.getElementById("theme-toggle");

  // Restore saved theme
  const savedTheme = localStorage.getItem("theme");
  if (savedTheme) body.dataset.theme = savedTheme;

  // Add event listener
  toggleBtn.addEventListener("click", () => {
    const newTheme = body.dataset.theme === "light" ? "dark" : "light";
    body.dataset.theme = newTheme;
    localStorage.setItem("theme", newTheme);
  });
});