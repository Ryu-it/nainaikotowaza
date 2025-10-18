import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="accordion"
export default class extends Controller {
  static targets = ["content"]

  toggle() {
    this.contentTarget.hidden = !this.contentTarget.hidden
  }
}
