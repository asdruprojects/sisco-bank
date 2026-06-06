class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents, id: :uuid do |t|
      t.references :client, null: false, foreign_key: true, type: :uuid
      t.string :document_type, null: false
      t.string :document_number, null: false
      t.date :issued_at, null: false
      t.date :expires_at, null: false

      t.timestamps
    end

    add_index :documents, [:document_type, :document_number], unique: true
    add_check_constraint :documents, "document_type IN ('cedula', 'pasaporte', 'rif')", name: 'check_document_type'
  end
end