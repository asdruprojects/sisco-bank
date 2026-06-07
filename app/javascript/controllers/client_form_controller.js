import { Controller } from "@hotwired/stimulus"

// Alterna los campos del formulario segun el tipo de persona elegido.
// Natural  -> nombre completo, documentos: cedula o pasaporte
// Juridica -> razon social,    documentos: rif
export default class extends Controller {
  static targets = ["personType", "naturalBlock", "legalBlock", "documentType"]

  connect() {
    this.toggle()
  }

  toggle() {
    const type = this.personTypeTarget.value

    if (type === "natural") {
      this.enableBlock(this.naturalBlockTarget)
      this.disableBlock(this.legalBlockTarget)
      this.setDocumentOptions([["Cédula", "cedula"], ["Pasaporte", "pasaporte"]])
    } else if (type === "juridico") {
      this.disableBlock(this.naturalBlockTarget)
      this.enableBlock(this.legalBlockTarget)
      this.setDocumentOptions([["RIF", "rif"]])
    } else {
      this.disableBlock(this.naturalBlockTarget)
      this.disableBlock(this.legalBlockTarget)
      this.setDocumentOptions([])
    }
  }

  setDocumentOptions(options) {
    if (!this.hasDocumentTypeTarget) return

    const current = this.documentTypeTarget.value
    this.documentTypeTarget.innerHTML = ""

    const placeholder = document.createElement("option")
    placeholder.value = ""
    placeholder.textContent = "Seleccione..."
    this.documentTypeTarget.appendChild(placeholder)

    options.forEach(([label, value]) => {
      const option = document.createElement("option")
      option.value = value
      option.textContent = label
      if (value === current) option.selected = true
      this.documentTypeTarget.appendChild(option)
    })
  }

  enableBlock(block) {
    block.classList.remove("d-none")
    block.querySelectorAll("input, select, textarea").forEach((el) => {
      el.disabled = false
    })
  }

  disableBlock(block) {
    block.classList.add("d-none")
    block.querySelectorAll("input, select, textarea").forEach((el) => {
      el.disabled = true
    })
  }
}
