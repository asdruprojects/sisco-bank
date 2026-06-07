import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "clientName"]

  open(event) {
    const { clientName, formId } = event.params
    this.pendingForm = document.getElementById(formId)
    this.clientNameTarget.textContent = clientName

    window.bootstrap.Modal.getOrCreateInstance(this.modalTarget).show()
  }

  confirm(event) {
    event.preventDefault()

    if (this.pendingForm) {
      this.pendingForm.requestSubmit()
    }

    const modal = window.bootstrap.Modal.getInstance(this.modalTarget)
    if (modal) modal.hide()
  }
}
