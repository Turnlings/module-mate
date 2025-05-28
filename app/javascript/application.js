import { Application } from "@hotwired/stimulus"
import "chartkick"
import "chart.js"
import "chartjs-adapter-date-fns"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
