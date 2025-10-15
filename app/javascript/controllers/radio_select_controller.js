import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="radio-select"
export default class extends Controller {
  static targets = ["radio", "field"]
  static values = { name: String } // 行クリック用（rowClick）

  connect() {
    // 初期選択があれば反映
    const checked = this.radioTargets.find((r) => r.checked)
    if (checked) this.fieldTarget.value = checked.value
  }

  // ラジオの change で反映
  pick(event) {
    this.fieldTarget.value = event.target.value
  }

  // 行全体クリックで選択（フォローボタンは除外）
  rowClick(event) {
    // フォローボタン部に data-radio-select-ignore が付いていたら無視
    if (event.target.closest("[data-radio-select-ignore]")) return

    // その行のラジオをチェックして反映
    const radio = event.currentTarget.querySelector('input[type="radio"]')
    if (radio) {
      radio.checked = true
      this.fieldTarget.value = radio.value
    }
  }
}
