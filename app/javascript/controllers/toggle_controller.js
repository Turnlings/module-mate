import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "button"]

  toggle() {
    this.contentTarget.hidden = !this.contentTarget.hidden
    this.buttonTarget.textContent = this.contentTarget.hidden ? "More Stats" : "Hide Stats"
  }
}