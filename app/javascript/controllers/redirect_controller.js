import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="redirect"
export default class extends Controller {
  static values = {
    url: String
  }

  navigate() {
    if (this.hasUrlValue) {
      window.location.href = this.urlValue
    }
  }
}
