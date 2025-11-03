import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "image"]

  preview(event) {
    const file = event.target.files[0]
    const maxSizeInBytes = 10 * 1024 * 1024 // 10MB
    const validTypes = ["image/jpeg", "image/jpg", "image/png"]

    if (!validTypes.includes(file.type)) {
      alert("JPEG、JPG、PNG形式のファイルを選択してください。")
      this.removeImage()
      return
    }

    if (file.size < maxSizeInBytes) {
      const reader = new FileReader()
      reader.readAsDataURL(file)
      reader.onload = (e) => {
        this.imageTarget.src = e.target.result
        this.previewTarget.classList.remove("hidden")
      }
    } else {
      alert("ファイルサイズは10MB以下にしてください。")
      this.removeImage()
    }
  }

  removeImage() {
    this.inputTarget.value = null
    this.imageTarget.src = null
    this.previewTarget.classList.add("hidden")
  }
}
