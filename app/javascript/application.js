//= require theme

import { Application } from "@hotwired/stimulus"          
import "@hotwired/turbo-rails"    
import "chartkick"
import "chart.js"
import "chartjs-adapter-date-fns"
import ClipboardJS from "clipboard";

function setupClipboard() {
  if (window._clipboardInstance) {
    window._clipboardInstance.destroy();
  }
  if (document.getElementById('copy-share-link')) {
    window._clipboardInstance = new ClipboardJS('#copy-share-link');
    window._clipboardInstance.on('success', function(e) {
      var success = document.getElementById('copy-success');
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
