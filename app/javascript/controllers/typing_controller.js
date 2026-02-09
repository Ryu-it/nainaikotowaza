import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static values = {
    roomId: Number,
  }

  static targets = [
    "word1",
    "word2",
    "title",
    "meaning",
    "example",
    "word1Preview",
    "word2Preview",
    "titlePreview",
    "meaningPreview",
    "examplePreview",
  ]

  connect() {
    this.subscription = consumer.subscriptions.create(
      {
        channel: "TypingChannel",
        room_id: this.roomIdValue,
      },
      {
        received: (data) => this.applyPreview(data),
      },
    )
  }

  disconnect() {
    if (this.subscription) {
      consumer.subscriptions.remove(this.subscription)
    }
  }

  // 入力イベントから呼ぶ（word1 / word2 / title / meaning / example どれでもOK）
  syncFromForm() {
    const payload = {}
  
    if (this.hasWord1Target) payload.word1 = this.word1Target.value
    if (this.hasWord2Target) payload.word2 = this.word2Target.value
    if (this.hasTitleTarget) payload.title = this.titleTarget.value
    if (this.hasMeaningTarget) payload.meaning = this.meaningTarget.value
    if (this.hasExampleTarget) payload.example = this.exampleTarget.value
  
    this.subscription.send(payload)
    this.applyPreview(payload)
  }

  applyPreview(data) {
    if (this.hasWord1PreviewTarget && "word1" in data) {
      this.word1PreviewTarget.textContent =
        data.word1 || "まだありません"
    }
  
    if (this.hasWord2PreviewTarget && "word2" in data) {
      this.word2PreviewTarget.textContent =
        data.word2 || "まだありません"
    }
  
    if (this.hasTitlePreviewTarget && "title" in data) {
      this.titlePreviewTarget.textContent =
        data.title || "ないないことわざ"
    }
  
    if (this.hasMeaningPreviewTarget && "meaning" in data) {
      this.meaningPreviewTarget.textContent =
        data.meaning || "意味"
    }
  
    if (this.hasExamplePreviewTarget && "example" in data) {
      this.examplePreviewTarget.textContent =
        data.example || "用例"
    }
  }
}
