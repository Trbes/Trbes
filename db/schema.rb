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

ActiveRecord::Schema.define(version: 20150127190607) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.string   "image",           null: false
    t.string   "attachable_type", null: false
    t.integer  "attachable_id",   null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "attachments", ["attachable_id"], name: "index_attachments_on_attachable_id", using: :btree

  create_table "collection_posts", force: :cascade do |t|
    t.integer  "post_id",       null: false
    t.integer  "collection_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "collection_posts", ["collection_id"], name: "index_collection_posts_on_collection_id", using: :btree
  add_index "collection_posts", ["post_id"], name: "index_collection_posts_on_post_id", using: :btree

  create_table "collections", force: :cascade do |t|
    t.string   "image",       null: false
    t.string   "name",        null: false
    t.text     "description"
    t.integer  "group_id",    null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "collections", ["group_id"], name: "index_collections_on_group_id", using: :btree

  create_table "documents", force: :cascade do |t|
    t.string   "title",      limit: 255, null: false
    t.string   "url",        limit: 255, null: false
    t.text     "body",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",                        null: false
    t.text     "description"
    t.boolean  "private",     default: false
    t.string   "subdomain",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "image_postables", force: :cascade do |t|
    t.string "title"
  end

  create_table "link_postables", force: :cascade do |t|
    t.string "title"
    t.string "link"
  end

  create_table "membership_roles", force: :cascade do |t|
    t.integer  "membership_id", null: false
    t.integer  "role_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "membership_roles", ["membership_id"], name: "index_membership_roles_on_membership_id", using: :btree
  add_index "membership_roles", ["role_id"], name: "index_membership_roles_on_role_id", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string  "order_number",      limit: 255, null: false
    t.string  "url",               limit: 255, null: false
    t.text    "keyword"
    t.text    "secondary_keyword"
    t.text    "title"
    t.text    "description"
    t.text    "heading"
    t.integer "document_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "group_id",      null: false
    t.integer  "user_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "postable_id"
    t.string   "postable_type"
  end

  add_index "posts", ["group_id"], name: "index_posts_on_group_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "text_postables", force: :cascade do |t|
    t.string "title"
    t.text   "body"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "collection_posts", "collections"
  add_foreign_key "collection_posts", "posts"
  add_foreign_key "collections", "groups"
  add_foreign_key "membership_roles", "memberships"
  add_foreign_key "membership_roles", "roles"
  add_foreign_key "memberships", "groups"
  add_foreign_key "memberships", "users"
  add_foreign_key "posts", "groups"
  add_foreign_key "posts", "users"
end
