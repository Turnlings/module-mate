import { Application } from "@hotwired/stimulus"          
import "@hotwired/turbo-rails"    
import "chartkick"
import "chart.js"
import "chartjs-adapter-date-fns"

import ClipboardJS from "clipboard";

document.addEventListener('DOMContentLoaded', function() {
  var clipboard = new ClipboardJS('#copy-share-link');
  clipboard.on('success', function(e) {
    var success = document.getElementById('copy-success');
    if (success) {
      success.style.display = 'inline';
      setTimeout(function() { success.style.display = 'none'; }, 1500);
    }
    e.clearSelection();
  });
});

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
