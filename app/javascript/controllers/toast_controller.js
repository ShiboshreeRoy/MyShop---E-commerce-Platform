import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toast"]
  static values = {
    message: String,
    type: { type: String, default: "info" }
  }

  connect() {
    if (this.messageValue) {
      this.showToast(this.messageValue, this.typeValue)
    }
  }

  showToast(message, type = 'info') {
    const toastContainer = this.createToastContainer()
    const toastElement = this.createToastElement(message, type)
    
    toastContainer.appendChild(toastElement)
    document.body.appendChild(toastContainer)
    
    // Auto-hide after 5 seconds
    setTimeout(() => {
      this.hideToast(toastElement, toastContainer)
    }, 5000)
  }

  createToastContainer() {
    let container = document.getElementById('toast-container')
    if (!container) {
      container = document.createElement('div')
      container.id = 'toast-container'
      container.className = 'fixed inset-0 flex items-start justify-end pointer-events-none z-50 p-4 space-y-2'
    }
    return container
  }

  createToastElement(message, type) {
    const toast = document.createElement('div')
    toast.className = `toast-item transform transition-all duration-300 ease-in-out opacity-0 translate-y-2 p-4 rounded-lg shadow-lg text-white max-w-xs pointer-events-auto mb-2 ${
      type === 'success' ? 'bg-green-500' :
      type === 'error' ? 'bg-red-500' :
      type === 'warning' ? 'bg-yellow-500' :
      'bg-blue-500'
    }`
    
    toast.innerHTML = `
      <div class="flex items-start">
        <div class="flex-1">
          <p class="text-sm font-medium">${message}</p>
        </div>
        <button class="ml-4 text-white hover:text-gray-200 focus:outline-none" onclick="this.closest('.toast-item').remove()">
          <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>
    `
    
    // Trigger enter animation
    setTimeout(() => {
      toast.style.opacity = '1'
      toast.style.transform = 'translateY(0)'
    }, 10)
    
    return toast
  }

  hideToast(toastElement, container) {
    toastElement.style.transition = 'opacity 0.3s ease, transform 0.3s ease'
    toastElement.style.opacity = '0'
    toastElement.style.transform = 'translateY(-10px)'
    
    setTimeout(() => {
      toastElement.remove()
      if (container.children.length === 0) {
        container.remove()
      }
    }, 300)
  }

  showSuccess(event) {
    const message = event.detail.message || 'Operation successful!'
    this.showToast(message, 'success')
  }

  showError(event) {
    const message = event.detail.message || 'An error occurred!'
    this.showToast(message, 'error')
  }

  showInfo(event) {
    const message = event.detail.message || 'Information'
    this.showToast(message, 'info')
  }

  showWarning(event) {
    const message = event.detail.message || 'Warning!'
    this.showToast(message, 'warning')
  }
}