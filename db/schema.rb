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

ActiveRecord::Schema[7.2].define(version: 2025_10_28_050518) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "follows", force: :cascade do |t|
    t.bigint "follower_id", null: false
    t.bigint "followed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_follows_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_follows_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.bigint "inviter_id", null: false
    t.bigint "invitee_id", null: false
    t.datetime "expires_at", null: false
    t.datetime "used_at"
    t.boolean "revoked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_invitations_on_expires_at"
    t.index ["invitee_id"], name: "index_invitations_on_invitee_id"
    t.index ["inviter_id"], name: "index_invitations_on_inviter_id"
    t.index ["room_id"], name: "index_invitations_on_room_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "actor_id", null: false
    t.bigint "recipient_id", null: false
    t.integer "action", default: 0, null: false
    t.boolean "is_checked", default: false, null: false
    t.string "notifiable_type", null: false
    t.bigint "notifiable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_notifications_on_actor_id"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id"
    t.index ["recipient_id", "is_checked"], name: "index_notifications_on_recipient_id_and_is_checked"
    t.index ["recipient_id"], name: "index_notifications_on_recipient_id"
  end

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
    t.string "word1"
    t.string "word2"
    t.string "title"
    t.string "meaning"
    t.text "example"
    t.integer "status", default: 0, null: false
    t.bigint "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_proverbs_on_room_id"
    t.check_constraint "(status = 2) IS NOT TRUE OR title IS NOT NULL AND char_length(title::text) <= 50 AND meaning IS NOT NULL AND char_length(meaning::text) <= 100", name: "proverbs_title_meaning_required_when_completed"
    t.check_constraint "(status = ANY (ARRAY[1, 2])) IS NOT TRUE OR word1 IS NOT NULL AND char_length(word1::text) <= 10 AND word2 IS NOT NULL AND char_length(word2::text) <= 10", name: "proverbs_words_required_when_in_progress_or_completed"
    t.check_constraint "example IS NULL OR char_length(example) <= 300", name: "proverbs_example_max_length"
    t.check_constraint "status = ANY (ARRAY[0, 1, 2])", name: "proverbs_status_enum"
  end

  create_table "room_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "room_id", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_room_users_on_room_id"
    t.index ["user_id", "room_id"], name: "index_room_users_on_user_id_and_room_id", unique: true
    t.index ["user_id"], name: "index_room_users_on_user_id"
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
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "follows", "users", column: "followed_id"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "invitations", "rooms"
  add_foreign_key "invitations", "users", column: "invitee_id"
  add_foreign_key "invitations", "users", column: "inviter_id"
  add_foreign_key "notifications", "users", column: "actor_id"
  add_foreign_key "notifications", "users", column: "recipient_id"
  add_foreign_key "proverb_contributors", "proverbs"
  add_foreign_key "proverb_contributors", "users"
  add_foreign_key "proverbs", "rooms"
  add_foreign_key "room_users", "rooms"
  add_foreign_key "room_users", "users"
  add_foreign_key "rooms", "users", column: "owner_id"
end
