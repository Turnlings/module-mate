import { Application } from "@hotwired/stimulus"
import * as d3 from "d3";
import ChartController from "./controllers/chart_controller"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

// Register controllers
application.register("chart", ChartController) 

export { application }
