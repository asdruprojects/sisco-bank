class LegalEntity < ApplicationRecord
  belongs_to :client

  validate :company_name_valid, if: :juridico_client?

  private

  def juridico_client?
    client&.person_type == "juridico"
  end

  def company_name_valid
    if company_name.blank?
      errors.add(:company_name, "es obligatoria")
    elsif company_name !~ /\A[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s\.\,\-\&]+\z/
      errors.add(:company_name, "solo admite letras, espacios y caracteres permitidos")
    end
  end
end
