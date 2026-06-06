class Document < ApplicationRecord
    belongs_to :client
  
    TYPES = %w[cedula pasaporte rif].freeze
  
    validates :document_type,   presence: true, inclusion: { in: TYPES }
    validates :document_number, presence: true,
              uniqueness: { scope: :document_type, message: "ya está registrado para este tipo de documento" }
    validates :issued_at,  presence: true
    validates :expires_at, presence: true
  
    validate :expires_after_issued
  
    private
  
    def expires_after_issued
      return unless issued_at && expires_at
      if expires_at <= issued_at
        errors.add(:expires_at, "debe ser mayor a la fecha de emisión")
      end
    end
  end