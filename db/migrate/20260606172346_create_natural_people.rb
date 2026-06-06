class CreateNaturalPeople < ActiveRecord::Migration[8.0]
  def change
    create_table :natural_people, id: :uuid do |t|
      t.references :client, null: false, foreign_key: true, type: :uuid, index: { unique: true }
      t.string :full_name, null: false

      t.timestamps
    end
  end
end