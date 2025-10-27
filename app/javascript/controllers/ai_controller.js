import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="ai"
export default class extends Controller {
  // クリックしたボタンのUIを一時的にローディング状態へ
  setLoading(btn, isLoading, loadingText = "考え中…") {
    if (!btn) return
    if (isLoading) {
      // 元のテキストを保存（復帰用）
      if (!btn.dataset.defaultText) btn.dataset.defaultText = btn.textContent.trim()
      btn.textContent = loadingText
      btn.disabled = true
      btn.classList.add("opacity-60", "cursor-wait")
      btn.setAttribute("aria-busy", "true")
    } else {
      // 元に戻す
      const original = btn.dataset.defaultText || "実行"
      btn.textContent = original
      btn.disabled = false
      btn.classList.remove("opacity-60", "cursor-wait")
      btn.removeAttribute("aria-busy")
    }
  }

  // fetchを安全にするための簡易タイムアウト（任意）
  async fetchWithTimeout(resource, options = {}, timeoutMs = 10000) {
    const controller = new AbortController()
    const id = setTimeout(() => controller.abort(), timeoutMs)
    try {
      return await fetch(resource, { ...options, signal: controller.signal })
    } finally {
      clearTimeout(id)
    }
  }

  // 言葉の提案
  async generateWords(event) {
    event.preventDefault()
    const btn = event.currentTarget
    this.setLoading(btn, true, "考え中…")

    try {
      const response = await this.fetchWithTimeout("/ai/generate_words", {
        method: "POST",
        headers: {
          "Accept": "text/vnd.turbo-stream.html",
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
        }
      })

      if (!response.ok) throw new Error("AIリクエストに失敗しました")
      const html = await response.text()
      Turbo.renderStreamMessage(html) // ← サーバからの turbo_stream をそのまま適用
    } catch (error) {
      console.error("AI生成中にエラーが発生しました:", error)
      alert("AI生成に失敗しました。もう一度お試しください。")
    } finally {
      this.setLoading(btn, false)
    }
  }

  // ことわざ/意味/用例の生成
  async generateProverb(event) {
    event.preventDefault()
    const btn = event.currentTarget
    this.setLoading(btn, true, "考え中…")

    // フォームから値を取得
    const word1 = document.querySelector("#proverb_word1")?.value || ""
    const word2 = document.querySelector("#proverb_word2")?.value || ""

    try {
      const response = await this.fetchWithTimeout("/ai/generate_proverb", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "text/vnd.turbo-stream.html",
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
        },
        body: JSON.stringify({ word1, word2 })
      })

      if (!response.ok) throw new Error("AIリクエストに失敗しました")
      const html = await response.text()
      Turbo.renderStreamMessage(html) // ← サーバからの turbo_stream をそのまま適用
    } catch (error) {
      console.error("AI生成中にエラーが発生しました:", error)
      alert("AI生成に失敗しました。もう一度お試しください。")
    } finally {
      this.setLoading(btn, false)
    }
  }
}
