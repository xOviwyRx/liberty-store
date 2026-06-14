import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Clamps a number input to its own min/max attributes as the user types
  clamp() {
    const input = this.element
    if (input.value === "") return

    const value = Number(input.value)
    const min = Number(input.min || 0)

    if (value < min) input.value = min
    if (input.max !== "" && value > Number(input.max)) input.value = input.max
  }

  // Strip leading zeros once the user leaves the field
  normalize() {
    if (this.element.value !== "") this.element.value = Number(this.element.value)
  }
}
