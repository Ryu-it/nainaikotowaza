import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["label"]

  show() {
    this.labelTarget.classList.remove("opacity-0", "translate-y-1")
    this.labelTarget.classList.add("opacity-100", "translate-y-0")
  }

  hide() {
    this.labelTarget.classList.remove("opacity-100", "translate-y-0")
    this.labelTarget.classList.add("opacity-0", "translate-y-1")
  }
}
