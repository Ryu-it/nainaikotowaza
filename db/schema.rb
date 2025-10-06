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

ActiveRecord::Schema[7.2].define(version: 2025_10_06_060635) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "proverb_contributors", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "proverb_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.index ["proverb_id"], name: "index_proverb_contributors_on_proverb_id"
    t.index ["user_id"], name: "index_proverb_contributors_on_user_id"
  end

  create_table "proverbs", force: :cascade do |t|
    t.string "word1", null: false
    t.string "word2", null: false
    t.string "title", null: false
    t.string "meaning", null: false
    t.text "example"
    t.integer "status", default: 0, null: false
    t.bigint "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_proverbs_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "proverb_contributors", "proverbs"
  add_foreign_key "proverb_contributors", "users"
  add_foreign_key "proverbs", "rooms"
  add_foreign_key "rooms", "users", column: "owner_id"
end
