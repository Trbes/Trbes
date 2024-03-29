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

ActiveRecord::Schema.define(version: 20150608180910) do

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
    t.integer  "row_order"
    t.datetime "deleted_at"
  end

  add_index "collection_posts", ["collection_id"], name: "index_collection_posts_on_collection_id", using: :btree
  add_index "collection_posts", ["deleted_at"], name: "index_collection_posts_on_deleted_at", using: :btree
  add_index "collection_posts", ["post_id"], name: "index_collection_posts_on_post_id", using: :btree

  create_table "collections", force: :cascade do |t|
    t.string   "name",                                   null: false
    t.text     "description"
    t.integer  "group_id",                               null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "visibility",             default: false, null: false
    t.integer  "row_order"
    t.integer  "collection_posts_count", default: 0,     null: false
    t.string   "icon_class"
    t.datetime "deleted_at"
  end

  add_index "collections", ["deleted_at"], name: "index_collections_on_deleted_at", using: :btree
  add_index "collections", ["group_id"], name: "index_collections_on_group_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "post_id",                        null: false
    t.text     "body",                           null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "cached_votes_total", default: 0
    t.integer  "parent_comment_id"
    t.integer  "state",              default: 0, null: false
    t.boolean  "favourite"
    t.integer  "membership_id"
    t.datetime "deleted_at"
  end

  add_index "comments", ["cached_votes_total"], name: "index_comments_on_cached_votes_total", using: :btree
  add_index "comments", ["deleted_at"], name: "index_comments_on_deleted_at", using: :btree
  add_index "comments", ["membership_id"], name: "index_comments_on_membership_id", using: :btree
  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",                                   null: false
    t.text     "description"
    t.boolean  "private",                default: false
    t.string   "subdomain",                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "memberships_count",      default: 0,     null: false
    t.integer  "posts_count",            default: 0,     null: false
    t.integer  "collections_count",      default: 0,     null: false
    t.string   "tagline",                                null: false
    t.boolean  "allow_image_posts",      default: true,  null: false
    t.boolean  "allow_link_posts",       default: true,  null: false
    t.boolean  "allow_text_posts",       default: true,  null: false
    t.datetime "deleted_at"
    t.string   "custom_domain"
    t.integer  "published_posts_count",  default: 0,     null: false
    t.integer  "moderation_posts_count", default: 0,     null: false
    t.integer  "rejected_posts_count",   default: 0,     null: false
    t.string   "logo"
    t.string   "ga_tracking_id"
    t.string   "favicon"
  end

  add_index "groups", ["custom_domain"], name: "index_groups_on_custom_domain", using: :btree
  add_index "groups", ["deleted_at"], name: "index_groups_on_deleted_at", using: :btree

  create_table "image_postables", force: :cascade do |t|
  end

  create_table "link_postables", force: :cascade do |t|
    t.string "link"
  end

  create_table "mailkick_opt_outs", force: :cascade do |t|
    t.string   "email"
    t.integer  "user_id"
    t.string   "user_type"
    t.boolean  "active",     default: true, null: false
    t.string   "reason"
    t.string   "list"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mailkick_opt_outs", ["email"], name: "index_mailkick_opt_outs_on_email", using: :btree
  add_index "mailkick_opt_outs", ["user_id", "user_type"], name: "index_mailkick_opt_outs_on_user_id_and_user_type", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "role",       default: 3, null: false
    t.datetime "deleted_at"
  end

  add_index "memberships", ["deleted_at"], name: "index_memberships_on_deleted_at", using: :btree
  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "group_id",                           null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "cached_votes_total", default: 0
    t.integer  "comments_count",     default: 0,     null: false
    t.string   "slug",                               null: false
    t.string   "title",                              null: false
    t.integer  "post_type",          default: 0,     null: false
    t.string   "body"
    t.string   "link"
    t.integer  "state",              default: 0,     null: false
    t.datetime "deleted_at"
    t.float    "hot_rank",           default: 0.0,   null: false
    t.integer  "membership_id"
    t.boolean  "featured",           default: false, null: false
    t.float    "popular_rank",       default: 0.0,   null: false
  end

  add_index "posts", ["cached_votes_total"], name: "index_posts_on_cached_votes_total", using: :btree
  add_index "posts", ["deleted_at"], name: "index_posts_on_deleted_at", using: :btree
  add_index "posts", ["group_id", "state", "cached_votes_total", "created_at"], name: "posts_list_index", using: :btree
  add_index "posts", ["group_id"], name: "index_posts_on_group_id", using: :btree
  add_index "posts", ["membership_id"], name: "index_posts_on_membership_id", using: :btree
  add_index "posts", ["slug"], name: "index_posts_on_slug", unique: true, using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "super_admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "super_admins", ["email"], name: "index_super_admins_on_email", unique: true, using: :btree
  add_index "super_admins", ["reset_password_token"], name: "index_super_admins_on_reset_password_token", unique: true, using: :btree

  create_table "text_postables", force: :cascade do |t|
    t.text "body"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
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
    t.integer  "comments_count",         default: 0,  null: false
    t.string   "title"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.string   "avatar"
    t.datetime "deleted_at"
  end

  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

  add_foreign_key "collection_posts", "collections"
  add_foreign_key "collection_posts", "posts"
  add_foreign_key "collections", "groups"
  add_foreign_key "comments", "memberships"
  add_foreign_key "comments", "posts"
  add_foreign_key "memberships", "groups"
  add_foreign_key "memberships", "users"
  add_foreign_key "posts", "groups"
  add_foreign_key "posts", "memberships"
  add_foreign_key "profiles", "users"
end
