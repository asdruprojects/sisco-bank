class Document < ApplicationRecord
  belongs_to :client

  TYPES = %w[cedula pasaporte rif].freeze

  validate :document_type_valid
  validates :document_number, presence: { message: "es obligatorio" },
            uniqueness: { scope: :document_type, message: "ya está registrado para este tipo de documento" }
  validates :issued_at, presence: { message: "es obligatoria" }
  validates :expires_at, presence: { message: "es obligatoria" }

  validate :expires_after_issued

  private

  def document_type_valid
    if document_type.blank?
      errors.add(:document_type, "es obligatorio")
    elsif !TYPES.include?(document_type)
      errors.add(:document_type, "debe ser cédula, pasaporte o RIF")
    end
  end

  def expires_after_issued
    return unless issued_at && expires_at

    if expires_at <= issued_at
      errors.add(:expires_at, "debe ser mayor a la fecha de emisión")
    end
  end
end
