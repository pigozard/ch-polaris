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

ActiveRecord::Schema[7.1].define(version: 2026_03_13_145043) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "etp_programs", force: :cascade do |t|
    t.bigint "unit_id", null: false
    t.string "name", null: false
    t.text "description"
    t.text "target_audience"
    t.string "pathology", null: false
    t.text "prerequisites", null: false
    t.string "duration"
    t.string "modality", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unit_id"], name: "index_etp_programs_on_unit_id"
  end

  create_table "etp_sessions", force: :cascade do |t|
    t.bigint "etp_program_id", null: false
    t.string "session_type", null: false
    t.date "starts_on"
    t.date "ends_on"
    t.string "recurrence"
    t.integer "max_participants"
    t.integer "current_participants", default: 0
    t.string "location"
    t.string "status", default: "open", null: false
    t.text "registration_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["etp_program_id"], name: "index_etp_sessions_on_etp_program_id"
  end

  create_table "news", force: :cascade do |t|
    t.bigint "pole_id"
    t.string "title", null: false
    t.string "slug", null: false
    t.text "summary"
    t.string "category", null: false
    t.datetime "published_at"
    t.boolean "published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pole_id"], name: "index_news_on_pole_id"
    t.index ["published"], name: "index_news_on_published"
    t.index ["slug"], name: "index_news_on_slug", unique: true
  end

  create_table "poles", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description"
    t.string "color", null: false
    t.integer "position"
    t.boolean "transversal", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_poles_on_slug", unique: true
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "unit_id", null: false
    t.string "schedule_type", null: false
    t.time "opens_at"
    t.time "closes_at"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unit_id"], name: "index_schedules_on_unit_id"
  end

  create_table "sectors", force: :cascade do |t|
    t.bigint "unit_id", null: false
    t.string "postal_code", null: false
    t.string "city", null: false
    t.string "street_pattern"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["postal_code"], name: "index_sectors_on_postal_code"
    t.index ["unit_id"], name: "index_sectors_on_unit_id"
  end

  create_table "unit_regulations", force: :cascade do |t|
    t.bigint "unit_id", null: false
    t.integer "max_visitors"
    t.text "forbidden_items"
    t.text "allowed_items"
    t.text "visiting_notes"
    t.text "access_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unit_id"], name: "index_unit_regulations_on_unit_id"
  end

  create_table "units", force: :cascade do |t|
    t.bigint "pole_id", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.string "unit_type", null: false
    t.integer "capacity"
    t.string "phone"
    t.string "email"
    t.text "description"
    t.string "address"
    t.boolean "pmr_accessible", default: false, null: false
    t.string "parking_info"
    t.string "svg_zone_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pole_id"], name: "index_units_on_pole_id"
    t.index ["slug"], name: "index_units_on_slug", unique: true
    t.index ["unit_type"], name: "index_units_on_unit_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "etp_programs", "units"
  add_foreign_key "etp_sessions", "etp_programs"
  add_foreign_key "news", "poles"
  add_foreign_key "schedules", "units"
  add_foreign_key "sectors", "units"
  add_foreign_key "unit_regulations", "units"
  add_foreign_key "units", "poles"
end
