# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_06_172353) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "clients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "email", null: false
    t.string "person_type", null: false
    t.string "phone_primary", null: false
    t.string "phone_secondary"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_clients_on_deleted_at"
    t.index ["email"], name: "index_clients_on_email", unique: true
    t.check_constraint "person_type::text = ANY (ARRAY['natural'::character varying, 'juridico'::character varying]::text[])", name: "check_person_type"
  end

  create_table "documents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "client_id", null: false
    t.datetime "created_at", null: false
    t.string "document_number", null: false
    t.string "document_type", null: false
    t.date "expires_at", null: false
    t.date "issued_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_documents_on_client_id"
    t.index ["document_type", "document_number"], name: "index_documents_on_document_type_and_document_number", unique: true
    t.check_constraint "document_type::text = ANY (ARRAY['cedula'::character varying, 'pasaporte'::character varying, 'rif'::character varying]::text[])", name: "check_document_type"
  end

  create_table "legal_entities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "client_id", null: false
    t.string "company_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_legal_entities_on_client_id", unique: true
  end

  create_table "natural_people", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "client_id", null: false
    t.datetime "created_at", null: false
    t.string "full_name", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_natural_people_on_client_id", unique: true
  end

  add_foreign_key "documents", "clients"
  add_foreign_key "legal_entities", "clients"
  add_foreign_key "natural_people", "clients"
end
