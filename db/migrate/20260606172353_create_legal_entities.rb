class CreateLegalEntities < ActiveRecord::Migration[8.0]
  def change
    create_table :legal_entities, id: :uuid do |t|
      t.references :client, null: false, foreign_key: true, type: :uuid, index: { unique: true }
      t.string :company_name, null: false

      t.timestamps
    end
  end
end
