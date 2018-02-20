# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180216173101) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorities", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "website"
    t.string "password_digest", null: false
    t.string "city"
    t.string "zip"
    t.string "country"
    t.string "state"
    t.string "organization"
    t.bigint "next_serial", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_authorities_on_email", unique: true
    t.index ["name"], name: "index_authorities_on_name", unique: true
  end

  create_table "authorities_csr", force: :cascade do |t|
    t.integer "authority_id"
    t.integer "csr_id"
  end

  create_table "authorities_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "authority_id", null: false
    t.index ["authority_id"], name: "index_authorities_users_on_authority_id"
    t.index ["user_id"], name: "index_authorities_users_on_user_id"
  end

  create_table "cert_profile_constraints", force: :cascade do |t|
    t.bigint "profile_id", null: false
    t.string "type", null: false
    t.jsonb "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_cert_profile_constraints_on_profile_id"
  end

  create_table "cert_profiles", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cert_signing_requests", force: :cascade do |t|
    t.string "subject_type", null: false
    t.bigint "subject_id", null: false
    t.bigint "subject_key_id", null: false
    t.bigint "profile_id", null: false
    t.bigint "certificate_id"
    t.string "name", null: false
    t.text "pem", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["certificate_id"], name: "index_cert_signing_requests_on_certificate_id"
    t.index ["profile_id"], name: "index_cert_signing_requests_on_profile_id"
    t.index ["subject_key_id"], name: "index_cert_signing_requests_on_subject_key_id"
    t.index ["subject_type", "subject_id"], name: "index_cert_signing_requests_on_subject_type_and_subject_id"
  end

  create_table "certificates", force: :cascade do |t|
    t.bigint "issuer_id", null: false
    t.bigint "issuer_key_id", null: false
    t.string "subject_type", null: false
    t.bigint "subject_id", null: false
    t.bigint "profile_id", null: false
    t.text "pem", null: false
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issuer_id"], name: "index_certificates_on_issuer_id"
    t.index ["issuer_key_id"], name: "index_certificates_on_issuer_key_id"
    t.index ["profile_id"], name: "index_certificates_on_profile_id"
    t.index ["subject_type", "subject_id"], name: "index_certificates_on_subject_type_and_subject_id"
  end

  create_table "crypto_keys", force: :cascade do |t|
    t.string "name", null: false
    t.string "owner_type"
    t.bigint "owner_id"
    t.text "private_pem", null: false
    t.text "public_pem", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_crypto_keys_on_owner_type_and_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "firstname"
    t.string "lastname"
    t.string "street"
    t.string "street2"
    t.string "city"
    t.string "zip"
    t.string "country"
    t.string "state"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "cert_profile_constraints", "cert_profiles", column: "profile_id"
  add_foreign_key "cert_signing_requests", "cert_profiles", column: "profile_id"
  add_foreign_key "cert_signing_requests", "crypto_keys", column: "subject_key_id"
  add_foreign_key "certificates", "authorities", column: "issuer_id"
  add_foreign_key "certificates", "cert_profiles", column: "profile_id"
  add_foreign_key "certificates", "crypto_keys", column: "issuer_key_id"
end
