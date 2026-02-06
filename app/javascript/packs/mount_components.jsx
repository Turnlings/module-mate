import React from "react";
import { createRoot } from "react-dom/client";

// Dynamically load all components from the components directory
const componentsContext = require.context("../components", true, /\.(js|jsx)$/);
const components = {};
componentsContext.keys().forEach((key) => {
  const name = key.replace(/^.*\/([^/]+)\.(js|jsx)$/, "$1");
  components[name] = componentsContext(key).default;
});

// Map to store roots for each container
const roots = new Map();

function mountComponents(root = document) {
  root.querySelectorAll("[data-react-component]").forEach((el) => {
    const name = el.dataset.reactComponent;
    const props = el.dataset.props ? JSON.parse(el.dataset.props) : {};
    const Component = components[name];

    if (Component) {
      if (!roots.has(el)) {
        const reactRoot = createRoot(el);
        roots.set(el, reactRoot);
        reactRoot.render(<Component {...props} />);
      } else {
        const reactRoot = roots.get(el);
        reactRoot.render(<Component {...props} />);
      }
    } else {
      console.error(`React component "${name}" not found.`);
    }
  });
}

document.addEventListener("turbo:load", () => mountComponents(document));
document.addEventListener("DOMContentLoaded", () => mountComponents(document));

// Ensure components mount when content is loaded into a Turbo Frame (e.g. modal)
document.addEventListener("turbo:frame-load", (event) => {
  mountComponents(event.target);
});
