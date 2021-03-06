# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20190127101741) do

  create_table "access_controls", force: :cascade do |t|
    t.boolean  "ability_to_post_ads"
    t.boolean  "ability_to_post_blog"
    t.boolean  "ability_to_verify_ads"
    t.boolean  "ability_to_change_categories"
    t.boolean  "ability_to_change_faqs"
    t.boolean  "ability_to_change_roles"
    t.boolean  "ability_to_assign_roles"
    t.string   "uuid",                         limit: 255
    t.string   "role_id",                      limit: 255
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "access_controls", ["role_id"], name: "index_access_controls_on_role_id", using: :btree
  add_index "access_controls", ["uuid"], name: "index_access_controls_on_uuid", unique: true, using: :btree

  create_table "advertisements", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.text     "content",          limit: 65535
    t.string   "uuid",             limit: 255
    t.string   "category_id",      limit: 255
    t.integer  "size",             limit: 4
    t.boolean  "view_in_homepage"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "rank",             limit: 4
    t.integer  "user_id",          limit: 4
    t.integer  "status",           limit: 4
    t.string   "address",          limit: 255
    t.string   "province_id",      limit: 255
    t.string   "city",             limit: 255
    t.string   "email",            limit: 255
    t.string   "telegram_channel", limit: 255
    t.string   "instagram_page",   limit: 255
    t.string   "website",          limit: 255
    t.string   "phone_number",     limit: 255
    t.integer  "integer_id",       limit: 4
    t.string   "price",            limit: 255
    t.string   "mobile",           limit: 255
  end

  add_index "advertisements", ["category_id"], name: "index_advertisements_on_category_id", using: :btree
  add_index "advertisements", ["uuid"], name: "index_advertisements_on_uuid", unique: true, using: :btree

  create_table "assignments", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "role_id",    limit: 255
    t.string   "uuid",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "assignments", ["role_id"], name: "index_assignments_on_role_id", using: :btree
  add_index "assignments", ["uuid"], name: "index_assignments_on_uuid", unique: true, using: :btree

  create_table "blogs", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.text     "content",          limit: 65535
    t.string   "uuid",             limit: 255
    t.boolean  "view_in_homepage"
    t.integer  "rank",             limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "abstract",         limit: 65535
  end

  add_index "blogs", ["uuid"], name: "index_blogs_on_uuid", unique: true, using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "uuid",       limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "integer_id", limit: 4
    t.integer  "rank",       limit: 4
    t.string   "parent_id",  limit: 255
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["uuid"], name: "index_categories_on_uuid", unique: true, using: :btree

  create_table "categorizations", force: :cascade do |t|
    t.string   "category_id",      limit: 255
    t.string   "advertisement_id", limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "uuid",             limit: 255
  end

  add_index "categorizations", ["advertisement_id"], name: "index_categorizations_on_advertisement_id", using: :btree
  add_index "categorizations", ["category_id"], name: "index_categorizations_on_category_id", using: :btree
  add_index "categorizations", ["uuid"], name: "index_categorizations_on_uuid", unique: true, using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "phone_number",     limit: 255
    t.string   "email",            limit: 255
    t.string   "telegram_channel", limit: 255
    t.string   "instagram_page",   limit: 255
    t.string   "address",          limit: 255
    t.text     "about_us",         limit: 65535
    t.string   "uuid",             limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "fax",              limit: 255
  end

  add_index "companies", ["uuid"], name: "index_companies_on_uuid", unique: true, using: :btree

  create_table "devices", force: :cascade do |t|
    t.string   "device_uuid", limit: 255
    t.string   "fcm_token",   limit: 255
    t.integer  "user_id",     limit: 4
    t.string   "uuid",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "devices", ["device_uuid"], name: "index_devices_on_device_uuid", using: :btree
  add_index "devices", ["fcm_token"], name: "index_devices_on_fcm_token", using: :btree
  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree
  add_index "devices", ["uuid"], name: "index_devices_on_uuid", unique: true, using: :btree

  create_table "faqs", force: :cascade do |t|
    t.string   "question",   limit: 255
    t.text     "answer",     limit: 65535
    t.string   "uuid",       limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "faqs", ["uuid"], name: "index_faqs_on_uuid", unique: true, using: :btree

  create_table "likes", force: :cascade do |t|
    t.string   "likeable_id",   limit: 255
    t.string   "likeable_type", limit: 255
    t.string   "uuid",          limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "user_id",       limit: 4
    t.string   "device_id",     limit: 255
  end

  add_index "likes", ["likeable_id"], name: "index_likes_on_likeable_id", using: :btree
  add_index "likes", ["likeable_type"], name: "index_likes_on_likeable_type", using: :btree
  add_index "likes", ["uuid"], name: "index_likes_on_uuid", unique: true, using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "room_id",    limit: 255
    t.string   "content",    limit: 255
    t.string   "uuid",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "messages", ["room_id"], name: "index_messages_on_room_id", using: :btree
  add_index "messages", ["uuid"], name: "index_messages_on_uuid", unique: true, using: :btree

  create_table "pins", force: :cascade do |t|
    t.string   "advertisement_id", limit: 255
    t.string   "uuid",             limit: 255
    t.integer  "user_id",          limit: 4
    t.string   "device_id",        limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "pins", ["advertisement_id"], name: "index_pins_on_advertisement_id", using: :btree
  add_index "pins", ["device_id"], name: "index_pins_on_device_id", using: :btree
  add_index "pins", ["uuid"], name: "index_pins_on_uuid", unique: true, using: :btree

  create_table "profiles", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "sex",              limit: 255
    t.string   "uuid",             limit: 255
    t.integer  "user_id",          limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "phone_number",     limit: 255
    t.integer  "integer_id",       limit: 4
    t.string   "address",          limit: 255
    t.string   "province_id",      limit: 255
    t.string   "city",             limit: 255
    t.string   "email",            limit: 255
    t.string   "telegram_channel", limit: 255
    t.string   "instagram_page",   limit: 255
    t.string   "website",          limit: 255
    t.string   "mobile",           limit: 255
  end

  add_index "profiles", ["uuid"], name: "index_profiles_on_uuid", unique: true, using: :btree

  create_table "provinces", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "uuid",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "provinces", ["uuid"], name: "index_provinces_on_uuid", unique: true, using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "uuid",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "roles", ["uuid"], name: "index_roles_on_uuid", unique: true, using: :btree

  create_table "rooms", force: :cascade do |t|
    t.string   "advertisement_id", limit: 255
    t.integer  "user_id",          limit: 4
    t.string   "uuid",             limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "rooms", ["advertisement_id"], name: "index_rooms_on_advertisement_id", using: :btree
  add_index "rooms", ["uuid"], name: "index_rooms_on_uuid", unique: true, using: :btree

  create_table "seens", force: :cascade do |t|
    t.string   "room_id",    limit: 255
    t.integer  "user_id",    limit: 4
    t.string   "uuid",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "seens", ["room_id"], name: "index_seens_on_room_id", using: :btree
  add_index "seens", ["uuid"], name: "index_seens_on_uuid", unique: true, using: :btree

  create_table "uploads", force: :cascade do |t|
    t.string   "uploadable_type",         limit: 255
    t.string   "uploadable_id",           limit: 255
    t.string   "attachment_type",         limit: 255
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "attachment_file_name",    limit: 255
    t.string   "attachment_content_type", limit: 255
    t.integer  "attachment_file_size",    limit: 8
    t.datetime "attachment_updated_at"
  end

  add_index "uploads", ["attachment_type"], name: "index_uploads_on_attachment_type", using: :btree
  add_index "uploads", ["uploadable_id"], name: "index_uploads_on_uploadable_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "username",               limit: 255
    t.string   "mobile",                 limit: 255
    t.string   "fullname",               limit: 255
    t.string   "phone_number",           limit: 255
    t.string   "current_role_id",        limit: 255
  end

  add_index "users", ["current_role_id"], name: "index_users_on_current_role_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
