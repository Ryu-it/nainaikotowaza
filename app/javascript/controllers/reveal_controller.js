import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: Number }

  connect() {
    const delay = this.hasDelayValue ? this.delayValue : 400

    // より柔らかいトランジションに
    this.element.classList.add(
      "opacity-0", "translate-y-4", "scale-90",
      "transition-all", "duration-[2000ms]", "ease-out"
    )

    // 一瞬遅らせてふわっと出現
    setTimeout(() => {
      this.element.classList.add("opacity-100", "translate-y-0", "scale-100")
      this.element.classList.remove("opacity-0", "translate-y-4", "scale-90")
    }, delay)
  }
}
