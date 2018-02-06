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

ActiveRecord::Schema.define(version: 20180206160231) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorities", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "website", null: false
    t.string "password_digest", null: false
    t.text "sign_key_pem"
    t.text "encrypt_key_pem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_authorities_on_email", unique: true
    t.index ["name"], name: "index_authorities_on_name", unique: true
    t.index ["website"], name: "index_authorities_on_website", unique: true
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
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "cert_profile_constraints", "cert_profiles", column: "profile_id"
end
