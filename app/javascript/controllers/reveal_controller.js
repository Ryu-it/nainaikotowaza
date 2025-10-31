import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: Number }

  connect() {
    // 初期状態（ふわっと前）
    this.element.classList.add("opacity-0", "translate-y-2", "scale-95", "transition-all", "duration-700")

    const delay = this.hasDelayValue ? this.delayValue : 400
    setTimeout(() => {
      this.element.classList.add("opacity-100", "translate-y-0", "scale-100")
      this.element.classList.remove("opacity-0", "translate-y-2", "scale-95")
    }, delay)
  }
}
