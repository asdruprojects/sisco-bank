class LegalEntity < ApplicationRecord
  belongs_to :client

  validates :company_name, presence: true,
            format: {
              with: /\A[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s\.\,\-\&]+\z/,
              message: "solo letras, espacios y caracteres permitidos"
            }
end
