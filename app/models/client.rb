class Client < ApplicationRecord
  PHONE_FORMAT = /\A0\d+\z/
  PHONE_FORMAT_MESSAGE = "debe iniciar con cero y contener solo números"

  has_many :documents, dependent: :destroy
  has_one :natural_person, dependent: :destroy
  has_one :legal_entity, dependent: :destroy

  accepts_nested_attributes_for :documents
  accepts_nested_attributes_for :natural_person, reject_if: :all_blank
  accepts_nested_attributes_for :legal_entity, reject_if: :all_blank

  validates :person_type, presence: true, inclusion: { in: %w[natural juridico] }
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :phone_primary_valid
  validate :phone_secondary_valid

  attr_readonly :person_type

  validate :correct_subtype_present
  validate :person_type_cannot_change, on: :update

  scope :active, -> { where(deleted_at: nil) }
  scope :by_person_type, ->(type) { where(person_type: type) }
  scope :recent, -> { order(created_at: :desc) }
  scope :search_by_name, ->(name) {
    joins("LEFT JOIN natural_people ON natural_people.client_id = clients.id")
      .joins("LEFT JOIN legal_entities ON legal_entities.client_id = clients.id")
      .where("natural_people.full_name ILIKE ? OR legal_entities.company_name ILIKE ?",
             "%#{name}%", "%#{name}%")
  }
  scope :search_by_document, ->(number) {
    joins(:documents).where("documents.document_number ILIKE ?", "%#{number}%")
  }

  def soft_delete
    update(deleted_at: Time.current)
  end

  def display_name
    if person_type == "natural"
      natural_person&.full_name
    else
      legal_entity&.company_name
    end
  end

  def as_api_json
    {
      id: id,
      person_type: person_type,
      name: display_name,
      email: email,
      phone_primary: phone_primary,
      phone_secondary: phone_secondary,
      created_at: created_at,
      documents: documents.map do |d|
        {
          id: d.id,
          document_type: d.document_type,
          document_number: d.document_number,
          issued_at: d.issued_at,
          expires_at: d.expires_at
        }
      end
    }
  end

  private

  def correct_subtype_present
    if person_type == "natural" && natural_person.blank?
      errors.add(:base, "Persona natural debe tener nombre completo")
    elsif person_type == "juridico" && legal_entity.blank?
      errors.add(:base, "Persona jurídica debe tener razón social")
    end
  end

  def person_type_cannot_change
    return unless person_type_changed?

    errors.add(:person_type, "no puede modificarse después de crear el cliente")
  end

  def phone_primary_valid
    if phone_primary.blank?
      errors.add(:phone_primary, "es obligatorio")
    elsif phone_primary !~ PHONE_FORMAT
      errors.add(:phone_primary, PHONE_FORMAT_MESSAGE)
    end
  end

  def phone_secondary_valid
    return if phone_secondary.blank?

    if phone_secondary !~ PHONE_FORMAT
      errors.add(:phone_secondary, PHONE_FORMAT_MESSAGE)
    end
  end
end
