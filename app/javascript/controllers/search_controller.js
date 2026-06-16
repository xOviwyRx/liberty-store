import { Controller } from "@hotwired/stimulus"

// Submits the search form a short beat after the user stops typing,
// so the Turbo Frame refreshes without a request on every keystroke.
export default class extends Controller {
  static values = { delay: { type: Number, default: 300 } }

  submit() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => this.element.requestSubmit(), this.delayValue)
  }
}
