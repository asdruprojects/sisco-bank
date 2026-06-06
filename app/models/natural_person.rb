class NaturalPerson < ApplicationRecord
    belongs_to :client
  
    validates :full_name, presence: true,
              format: {
                with: /\A[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+\z/,
                message: "solo letras, espacios, acentos y ñ"
              }
  end