import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    titles: Array
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
    }, 12000) // ← 👈 初回遅延（ms）
  }

  showRandomTitle() {
    if (this.titlesValue.length === 0) return

    // ランダムにことわざタイトルを選択
    const text = this.titlesValue[Math.floor(Math.random() * this.titlesValue.length)]
    const elem = document.createElement("div")

    elem.className = "floating-text text-2xl text-pink-50 drop-shadow-[0_15px_35px_rgba(10,10,20,0.65)]"
    elem.textContent = text

    // ランダム位置（端で切れないように余白を確保）
    const field = this.element
    const fieldWidth = field.offsetWidth
    const fieldHeight = field.offsetHeight

    // 枠サイズに応じて余白を決める（15%は安全地帯にする）
    const paddingX = fieldWidth * 0.15   // 左右の端から15%は使わない
    const paddingY = fieldHeight * 0.15  // 上下の端から15%は使わない

    const x = Math.random() * (fieldWidth - paddingX * 2) + paddingX
    const y = Math.random() * (fieldHeight - paddingY * 2) + paddingY

    elem.style.left = `${x}px`
    elem.style.top = `${y}px`
    elem.style.position = "absolute"

    // elemをこ要素に追加
    field.appendChild(elem)

    // アニメーション終了後に削除（4s）
    setTimeout(() => elem.remove(), 4000)
  }
}
