// app/javascript/controllers/ai_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  setLoading(btn, isLoading, loadingText = "考え中…") {
    if (!btn) return
    if (isLoading) {
      if (!btn.dataset.defaultText) btn.dataset.defaultText = btn.textContent.trim()
      btn.textContent = loadingText
      btn.disabled = true
      btn.classList.add("opacity-60", "cursor-wait")
      btn.setAttribute("aria-busy", "true")
    } else {
      const original = btn.dataset.defaultText || "実行"
      btn.textContent = original
      btn.disabled = false
      btn.classList.remove("opacity-60", "cursor-wait")
      btn.removeAttribute("aria-busy")
    }
  }

  async generateWords(event) {
    event.preventDefault()
    const btn = event.currentTarget
    this.setLoading(btn, true, "考え中…")

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
    } finally {
      this.setLoading(btn, false)
    }
  }

  // ことわざ/意味/用例の生成
  generateProverb(event) {
    event.preventDefault()
    const btn = event.currentTarget
    this.setLoading(btn, true, "考え中…")

    const word1 = document.querySelector("#proverb_word1")?.value || ""
    const word2 = document.querySelector("#proverb_word2")?.value || ""

    if (!word1 || !word2) {
      alert("言葉が入力されていません。2つの言葉を入力してください。")
      this.setLoading(btn, false)
      return
    }

    // 対象フォームを取得 & 中身をリセット
    const titleInput   = document.querySelector("#proverb_title")
    const meaningInput = document.querySelector("#proverb_meaning")
    const exampleInput = document.querySelector("#proverb_example")

    if (titleInput)   titleInput.value   = ""
    if (meaningInput) meaningInput.value = ""
    if (exampleInput) exampleInput.value = ""

    const url = `/ai/generate_proverb?word1=${encodeURIComponent(word1)}&word2=${encodeURIComponent(word2)}`
    const es  = new EventSource(url)

    es.onmessage = (event) => {
      const data = JSON.parse(event.data)

      if (data.event === "chunk") {
        // その時点までの全文で上書き
        if (titleInput)   titleInput.value   = data.title || ""
        if (meaningInput) meaningInput.value = data.meaning || ""
        if (exampleInput) exampleInput.value = data.example || ""
      } else if (data.event === "final") {
        // すでに form には全部入っている前提なので完了処理だけ
        this.setLoading(btn, false)
        es.close()
      }
    }

    es.onerror = () => {
      es.close()
      this.setLoading(btn, false)
      alert("AI生成中にエラーが発生しました。")
    }
  }
}
