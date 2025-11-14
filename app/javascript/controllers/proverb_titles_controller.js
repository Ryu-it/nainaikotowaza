import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    items: Array   // [{ title: "...", url: "...", users: ["太郎", "花子"] }, ...]
  }

  connect() {
    this.startDisplaying()
  }

  startDisplaying() {
    // 最初の出現を 9秒遅らせる
    setTimeout(() => {
      this.showRandomTitle()

      // その後は 3秒ごとに表示
      setInterval(() => this.showRandomTitle(), 3000)
    }, 9000)
  }

  showRandomTitle() {
    if (this.itemsValue.length === 0) return

    // ランダムに 1 件取り出す
    const item =
      this.itemsValue[Math.floor(Math.random() * this.itemsValue.length)]

    const field = this.element
    const fieldWidth = field.offsetWidth
    const fieldHeight = field.offsetHeight

    const paddingX = fieldWidth * 0.15
    const paddingY = fieldHeight * 0.15

    const x = Math.random() * (fieldWidth - paddingX * 2) + paddingX
    const y = Math.random() * (fieldHeight - paddingY * 2) + paddingY

    // ★ ここに追加して OK
  console.log("x:", x, "y:", y)

    // ① ラッパ（位置＆アニメーションを持つ要素）
    const wrapper = document.createElement("div")
    wrapper.style.left = `${x}px`
    wrapper.style.top = `${y}px`
    wrapper.style.transform = "translate(-50%, -50%)"
    wrapper.className =
      "floating-text text-pink-50 drop-shadow-[0_15px_35px_rgba(10,10,20,0.65)]"

    // ② ユーザー名部分（上に表示）
    if (item.users && item.users.length > 0) {
      const userElem = document.createElement("div")
      // 2人いるときは「太郎 × 花子」みたいに表示
      userElem.textContent = item.users.join(" × ")
      userElem.className = "text-sm sm:text-base text-rose-200 mb-1"
      wrapper.appendChild(userElem)
    }

    // ③ タイトル（リンク）
    const titleLink = document.createElement("a")
    titleLink.href = item.url
    titleLink.textContent = item.title
    titleLink.className =
      "text-3xl sm:text-4xl no-underline"

    wrapper.appendChild(titleLink)

    // ④ field に追加
    field.appendChild(wrapper)

    // 4秒後に消す
    setTimeout(() => wrapper.remove(), 4000)
  }
}
