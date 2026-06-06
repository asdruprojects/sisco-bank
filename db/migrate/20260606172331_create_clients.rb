class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients, id: :uuid do |t|
      t.string :person_type, null: false
      t.string :email, null: false
      t.string :phone_primary, null: false
      t.string :phone_secondary
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :clients, :email, unique: true
    add_index :clients, :deleted_at
    add_check_constraint :clients, "person_type IN ('natural', 'juridico')", name: 'check_person_type'
  end
end
