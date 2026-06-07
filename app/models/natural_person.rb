class NaturalPerson < ApplicationRecord
  belongs_to :client

  validate :full_name_valid, if: :natural_client?

  private

  def natural_client?
    client&.person_type == "natural"
  end

  def full_name_valid
    if full_name.blank?
      errors.add(:full_name, "es obligatorio")
    elsif full_name !~ /\A[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+\z/
      errors.add(:full_name, "solo admite letras, espacios, acentos y ñ")
    end
  end
end
