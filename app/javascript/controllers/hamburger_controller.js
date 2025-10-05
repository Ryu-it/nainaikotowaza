import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hamburger"
export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.show = false
    this.outsideClickListener = this.outsideClick.bind(this)
    this.update()
  }

  toggle() {
    this.show = !this.show
    this.update()
    if (this.show) {
      document.addEventListener("click", this.outsideClickListener)
    } else {
      document.removeEventListener("click", this.outsideClickListener)
    }
  }

  outsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.show = false
      this.update()
      document.removeEventListener("click", this.outsideClickListener)
    }
  }

  update() {
    this.menuTarget.classList.toggle("hidden", !this.show)
  }
}
