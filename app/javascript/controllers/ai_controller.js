import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="ai"
export default class extends Controller {
  // asyncはawaitを使うために必要
  // preventDefaultはページのリロードを防ぐ
  async generateWords(event) {
    event.preventDefault()

    try {
      const response = await fetch("/ai/generate_words", {
        method: "POST",
        headers: {
          "Accept": "text/vnd.turbo-stream.html",
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
        }
      })

      if (!response.ok) throw new Error("AIリクエストに失敗しました")

      const html = await response.text()
      Turbo.renderStreamMessage(html)
    } catch (error) {
      console.error("AI生成中にエラーが発生しました:", error)
      alert("AI生成に失敗しました。もう一度お試しください。")
    }
  }

  async generateProverb(event) {
    event.preventDefault()

    // ← ここでフォームから値を取得！
    const word1 = document.querySelector("#proverb_word1").value
    const word2 = document.querySelector("#proverb_word2").value

    try {
      const response = await fetch("/ai/generate_proverb", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "text/vnd.turbo-stream.html",
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
        },
        body: JSON.stringify({ word1: word1, word2: word2 })
      })

      if (!response.ok) throw new Error("AIリクエストに失敗しました")

      const html = await response.text()
      Turbo.renderStreamMessage(html)
    } catch (error) {
      console.error("AI生成中にエラーが発生しました:", error)
      alert("AI生成に失敗しました。もう一度お試しください。")
    }
  }
}
