// controllers/motion_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sakuraLayer"]
  static values = {
    sakuraMinSize: Number,
    sakuraMaxSize: Number,
    sakuraMinSec: Number,
    sakuraMaxSec: Number,
    sakuraMaxDrift: Number
  }

  /* --- カーソルに沿って桜を舞わせる --- */
  connect() {
    this.enableCursorTrail()
  }

  /* --- イベントを解除 --- */
  disconnect() {
    if (this.boundPointerMove) {
      window.removeEventListener("pointermove", this.boundPointerMove)
      this.boundPointerMove = null
    }
  }

  /* --- カーソルの移動イベントを監視 --- */
  enableCursorTrail() {
    this.lastTrailAt = 0
    this.boundPointerMove = this.handlePointerMove.bind(this)
    window.addEventListener("pointermove", this.boundPointerMove, { passive: true })
  }

  /* --- カーソルの座標を取得して、花びらを追加 --- */
  handlePointerMove(event) {
    const now = performance.now()
    if (now - this.lastTrailAt < 120) return
    this.lastTrailAt = now

    const rect = this.sakuraLayerTarget.getBoundingClientRect()
    const x = event.clientX - rect.left
    const y = event.clientY - rect.top
    this.addTrailPetal(x, y)
  }

  /* --- 実際に花びら要素を生成 --- */
  addTrailPetal(x, y) {
    const el = document.createElement("div")
    el.className = "sakura-petal sakura-petal--trail"

    const rand = (min, max) => Math.random() * (max - min) + min
    const minSize = this.sakuraMinSizeValue || 8
    const maxSize = this.sakuraMaxSizeValue || 14
    const size = rand(minSize, maxSize)
    const duration = rand(3, 5)

    Object.assign(el.style, {
      width: `${size}px`,
      height: `${size * 0.8}px`,
      left: `${x + rand(-18, 18)}px`,
      top: `${y + rand(-12, 12)}px`,
      animationDuration: `${duration}s`
    })
    el.style.setProperty("--drift-x", `${rand(-120, 120)}px`)
    el.style.setProperty("--start-tilt", `${rand(-20, 20)}deg`)
    el.style.setProperty("--end-tilt", `${rand(220, 360)}deg`)
    el.style.setProperty("--start-scale", `${rand(0.9, 1.1)}`)

    this.sakuraLayerTarget.appendChild(el)
    window.setTimeout(() => el.remove(), duration * 1000 + 500)
  }
}
