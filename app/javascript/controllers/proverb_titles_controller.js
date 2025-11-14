import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    items: Array   // [{ title: "...", url: "..." }, ...]
  }

  connect() {
    this.startDisplaying()
  }

  startDisplaying() {
    // 最初の出現を 12秒遅らせる
    setTimeout(() => {
      this.showRandomTitle()

      // その後は 3秒ごとに表示
      setInterval(() => this.showRandomTitle(), 3000)
    }, 9000)
  }

  showRandomTitle() {
    if (this.itemsValue.length === 0) return

    // ① ランダムに 1 件取り出す
    const item =
      this.itemsValue[Math.floor(Math.random() * this.itemsValue.length)]

    // ② aタグを作る
    const elem = document.createElement("a")

    // ③ 遷移先と表示文字
    elem.href = item.url
    elem.textContent = item.title

    elem.className =
      "floating-text text-4xl text-pink-50 drop-shadow-[0_15px_35px_rgba(10,10,20,0.65)] no-underline"

    // ランダム位置
    const field = this.element
    const fieldWidth = field.offsetWidth
    const fieldHeight = field.offsetHeight

    const paddingX = fieldWidth * 0.15
    const paddingY = fieldHeight * 0.15

    const x = Math.random() * (fieldWidth - paddingX * 2) + paddingX
    const y = Math.random() * (fieldHeight - paddingY * 2) + paddingY

    elem.style.left = `${x}px`
    elem.style.top = `${y}px`
    elem.style.position = "absolute"

    field.appendChild(elem)

    // 4秒後に消す
    setTimeout(() => elem.remove(), 4000)
  }
}

