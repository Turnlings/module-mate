import { Application } from "@hotwired/stimulus"          
import "@hotwired/turbo-rails"    
import Chartkick from "chartkick"
import Chart from "chart.js/auto"
Chartkick.use(Chart)
import "chartjs-adapter-date-fns"
import ClipboardJS from "clipboard";
import "./theme.js"
import "./mount_components";
import "bootstrap/dist/js/bootstrap.bundle";
import "./offcanvas_modal_fix";
import "./CountdownTimer";

// Support component names relative to this directory:
var componentRequireContext = require.context("../components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);


function setupClipboard() {
  // Clean up old instance
  if (window._clipboardInstance) {
    window._clipboardInstance.destroy();
  }

  // Use class instead of ID, e.g. <button class="copy-btn" data-clipboard-text="...">
  var buttons = document.querySelectorAll('.copy-btn');
  if (buttons.length > 0) {
    window._clipboardInstance = new ClipboardJS('.copy-btn');

    window._clipboardInstance.on('success', function(e) {
      // Find the related success element next to the clicked button
      var success = e.trigger.parentElement.querySelector('.copy-success');
      if (success) {
        success.style.display = 'inline';
        setTimeout(function() { success.style.display = 'none'; }, 1500);
      }
      e.clearSelection();
    });
  }
}

function redrawCharts() {
  if (window.Chartkick && Chartkick.charts) {
    for (const chartId in Chartkick.charts) {
      Chartkick.charts[chartId].redraw();
    }
  }
}

// Redraw on resize
window.addEventListener('resize', redrawCharts);

// Redraw on Turbo page load
document.addEventListener('turbo:load', () => {
  setupClipboard();
  redrawCharts();
});

// Fix for the graphs flitting in and out on turbo render
Chartkick.config.autoDestroy = false

window.addEventListener('turbo:before-render', () => {
  Chartkick.eachChart(chart => {
    if (!chart.element.isConnected) {
      chart.destroy()
      delete Chartkick.charts[chart.element.id]
    }
  })
})
// End of fix

// Redraw on normal load (non-Turbo fallback)
document.addEventListener('DOMContentLoaded', () => {
  setupClipboard();
  redrawCharts();
});

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
