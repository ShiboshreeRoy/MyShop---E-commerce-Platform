import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]
  static values = { type: String }

  connect() {
    // Listen for custom events to show/hide modal
    document.addEventListener(`show-modal-${this.typeValue}`, this.open.bind(this))
    document.addEventListener(`hide-modal-${this.typeValue}`, this.close.bind(this))
    
    // Add click outside handler
    this.element.addEventListener('click', this.handleOutsideClick.bind(this))
  }

  disconnect() {
    document.removeEventListener(`show-modal-${this.typeValue}`, this.open.bind(this))
    document.removeEventListener(`hide-modal-${this.typeValue}`, this.close.bind(this))
  }

  open() {
    if (this.hasModalTarget) {
      this.modalTarget.classList.remove('hidden')
      this.modalTarget.classList.add('flex')
      
      // Small delay to ensure the element is rendered before applying transition
      requestAnimationFrame(() => {
        this.modalTarget.classList.add('opacity-100')
        this.modalTarget.classList.remove('opacity-0')
      })
    }
  }

  close() {
    if (this.hasModalTarget) {
      // Apply exit transition
      this.modalTarget.classList.remove('opacity-100')
      this.modalTarget.classList.add('opacity-0')
      
      // Wait for transition to complete before hiding
      setTimeout(() => {
        this.modalTarget.classList.add('hidden')
        this.modalTarget.classList.remove('flex')
      }, 300)
    }
  }

  handleOutsideClick(event) {
    if (event.target === this.element && this.hasModalTarget) {
      this.close()
    }
  }

  // Method to handle escape key globally
  static escapeListener(event) {
    if (event.key === 'Escape') {
      // Dispatch close events for all modal types to ensure any open modal gets closed
      document.dispatchEvent(new CustomEvent('hide-modal-login'));
      document.dispatchEvent(new CustomEvent('hide-modal-signup'));
      document.dispatchEvent(new CustomEvent('hide-modal-reset-password'));
    }
  }
}