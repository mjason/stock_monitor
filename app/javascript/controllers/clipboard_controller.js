import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = ["content", "button"]

  static values = {
    confirm: { type: String, default: 'Copied' },
    delayMs: { type: Number, default: 2000 }
  }

  copy() {
    const text = this.contentTarget.innerText
    navigator.clipboard.writeText(text)
        .then(() => {
          // === USE `confirmValue`
          this.buttonTarget.textContent = this.confirmValue;
          setTimeout(() => {
            this.buttonTarget.textContent = "Copy";
            // USE `delayMsValue`
          }, this.delayMsValue);
        })
        .catch((error) => {
          console.error('Failed to copy text to clipboard:', error);
        });
  }
}
