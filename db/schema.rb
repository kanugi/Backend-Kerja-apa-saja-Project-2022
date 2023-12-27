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

ActiveRecord::Schema[7.0].define(version: 2022_12_21_071324) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "banks", force: :cascade do |t|
    t.string "name"
    t.text "logo_bank"
    t.string "account_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "check_ins", force: :cascade do |t|
    t.text "photo_check_in"
    t.point "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "worker_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.integer "category_id"
    t.string "phone_number"
    t.string "address"
    t.string "total_employer"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo_profile"
  end

  create_table "company_users", force: :cascade do |t|
    t.integer "company_id"
    t.integer "user_id"
    t.integer "role"
  end

  create_table "districts", id: false, force: :cascade do |t|
    t.integer "code", null: false
    t.integer "regency_code", null: false
    t.string "name", null: false
    t.index ["regency_code"], name: "index_districts_on_regency_code"
  end

  create_table "job_applications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "job_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.integer "status"
    t.string "description"
    t.string "duration"
    t.integer "salary"
    t.string "address"
    t.string "contact"
    t.integer "employer_id"
    t.integer "worker_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id"
    t.integer "man_power"
    t.string "title"
    t.string "employer_type"
    t.point "location"
    t.string "province"
    t.string "regency"
    t.string "district"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "user_id"
    t.integer "room_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category"
  end

  create_table "progresses", force: :cascade do |t|
    t.text "photo_before_progress"
    t.text "photo_after_progress"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "worker_id"
  end

  create_table "provinces", id: false, force: :cascade do |t|
    t.integer "code", null: false
    t.string "name", null: false
  end

  create_table "regencies", id: false, force: :cascade do |t|
    t.integer "code", null: false
    t.integer "province_code", null: false
    t.string "name", null: false
    t.index ["province_code"], name: "index_regencies_on_province_code"
  end

  create_table "room_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skill_users", force: :cascade do |t|
    t.integer "skill_id", null: false
    t.integer "user_id", null: false
  end

  create_table "skills", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "type"
    t.string "image"
    t.string "bank"
    t.string "account_number"
    t.boolean "is_verified", default: false
    t.integer "sender_id"
    t.string "sender_type"
    t.integer "receiver_id"
    t.string "receiver_type"
    t.integer "transaction_type"
  end

  create_table "user_banks", force: :cascade do |t|
    t.integer "bank_id"
    t.integer "user_id"
    t.string "account_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.date "dob"
    t.string "province"
    t.string "regency"
    t.string "district"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "photo_profile"
    t.string "name"
    t.integer "user_type"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "phone_number"
  end

  create_table "workers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "job_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
