class Client < ApplicationRecord
  has_many :documents, dependent: :destroy
  has_one :natural_person, dependent: :destroy
  has_one :legal_entity, dependent: :destroy

  accepts_nested_attributes_for :documents
  accepts_nested_attributes_for :natural_person
  accepts_nested_attributes_for :legal_entity

  validates :person_type, presence: true, inclusion: { in: %w[natural juridico] }
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_primary, presence: true,
            format: { with: /\A0\d+\z/, message: "solo números iniciando con cero" }
  validates :phone_secondary,
            format: { with: /\A0\d+\z/, message: "solo números iniciando con cero" },
            allow_blank: true

  validate :correct_subtype_present

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
    natural_person&.full_name || legal_entity&.company_name
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
end
