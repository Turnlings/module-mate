import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="assessment"
export default class extends Controller {
  static targets = ["type", "coursework"]
  static courseworkTypes = ["Coursework::Solo", "Coursework::Group"]

  connect() {
    this.toggle()
  }

  toggle() {
    const value = this.typeTarget.value

    this.courseworkTarget.style.display = this.constructor.courseworkTypes.includes(value) ? "block" : "none"
  }
}
