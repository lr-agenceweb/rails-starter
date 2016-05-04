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

ActiveRecord::Schema.define(version: 20160504115922) do

  create_table "adult_setting_translations", force: :cascade do |t|
    t.integer  "adult_setting_id", limit: 4,     null: false
    t.string   "locale",           limit: 255,   null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "title",            limit: 255
    t.text     "content",          limit: 65535
  end

  add_index "adult_setting_translations", ["adult_setting_id"], name: "index_adult_setting_translations_on_adult_setting_id", using: :btree
  add_index "adult_setting_translations", ["locale"], name: "index_adult_setting_translations_on_locale", using: :btree

  create_table "adult_settings", force: :cascade do |t|
    t.string   "redirect_link", limit: 255
    t.boolean  "enabled",                   default: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "backgrounds", force: :cascade do |t|
    t.integer  "attachable_id",      limit: 4
    t.string   "attachable_type",    limit: 255
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.text     "retina_dimensions",  limit: 65535
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "backgrounds", ["attachable_type", "attachable_id"], name: "index_backgrounds_on_attachable_type_and_attachable_id", using: :btree

  create_table "blog_categories", force: :cascade do |t|
    t.string   "name",        limit: 255,             null: false
    t.string   "slug",        limit: 255,             null: false
    t.integer  "blogs_count", limit: 4,   default: 0, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "blog_settings", force: :cascade do |t|
    t.boolean  "prev_next",  default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "blog_translations", force: :cascade do |t|
    t.integer  "blog_id",    limit: 4,     null: false
    t.string   "locale",     limit: 255,   null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "title",      limit: 255
    t.string   "slug",       limit: 255
    t.text     "content",    limit: 65535
  end

  add_index "blog_translations", ["blog_id"], name: "index_blog_translations_on_blog_id", using: :btree
  add_index "blog_translations", ["locale"], name: "index_blog_translations_on_locale", using: :btree

  create_table "blogs", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.string   "slug",             limit: 255
    t.text     "content",          limit: 65535
    t.boolean  "show_as_gallery",                default: false
    t.boolean  "allow_comments",                 default: true
    t.boolean  "online",                         default: true
    t.integer  "user_id",          limit: 4
    t.integer  "blog_category_id", limit: 4
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "blogs", ["blog_category_id"], name: "index_blogs_on_blog_category_id", using: :btree
  add_index "blogs", ["slug"], name: "index_blogs_on_slug", using: :btree
  add_index "blogs", ["user_id"], name: "index_blogs_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "color",              limit: 255
    t.boolean  "optional",                       default: false
    t.integer  "optional_module_id", limit: 4
    t.integer  "menu_id",            limit: 4
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "categories", ["menu_id"], name: "index_categories_on_menu_id", using: :btree
  add_index "categories", ["optional_module_id"], name: "index_categories_on_optional_module_id", using: :btree

  create_table "comment_settings", force: :cascade do |t|
    t.boolean  "should_signal",   default: true
    t.boolean  "send_email",      default: false
    t.boolean  "should_validate", default: true
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string   "title",            limit: 50,    default: ""
    t.string   "username",         limit: 255
    t.string   "email",            limit: 255
    t.text     "comment",          limit: 65535
    t.string   "token",            limit: 255
    t.string   "lang",             limit: 255
    t.boolean  "validated",                      default: false
    t.boolean  "signalled",                      default: false
    t.string   "ancestry",         limit: 255
    t.integer  "commentable_id",   limit: 4
    t.string   "commentable_type", limit: 255
    t.integer  "user_id",          limit: 4
    t.string   "role",             limit: 255,   default: "comments"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  add_index "comments", ["ancestry"], name: "index_comments_on_ancestry", using: :btree
  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.string   "locale",     limit: 255
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "longtext",   limit: 65535
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  add_index "delayed_jobs", ["queue"], name: "delayed_jobs_queue", using: :btree

  create_table "event_orders", force: :cascade do |t|
    t.string   "key",        limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "event_settings", force: :cascade do |t|
    t.integer  "event_order_id", limit: 4
    t.boolean  "prev_next",                default: false
    t.boolean  "show_map",                 default: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "event_settings", ["event_order_id"], name: "index_event_settings_on_event_order_id", using: :btree

  create_table "event_translations", force: :cascade do |t|
    t.integer  "event_id",   limit: 4,     null: false
    t.string   "locale",     limit: 255,   null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "title",      limit: 255
    t.string   "slug",       limit: 255
    t.text     "content",    limit: 65535
  end

  add_index "event_translations", ["event_id"], name: "index_event_translations_on_event_id", using: :btree
  add_index "event_translations", ["locale"], name: "index_event_translations_on_locale", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.string   "slug",            limit: 255
    t.text     "content",         limit: 65535
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "show_as_gallery",               default: false
    t.boolean  "show_calendar",                 default: false
    t.boolean  "online",                        default: true
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "events", ["slug"], name: "index_events_on_slug", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "guest_book_settings", force: :cascade do |t|
    t.boolean  "should_validate", default: true
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "guest_books", force: :cascade do |t|
    t.string   "username",   limit: 255,                   null: false
    t.string   "email",      limit: 255,                   null: false
    t.text     "content",    limit: 65535,                 null: false
    t.string   "lang",       limit: 255,                   null: false
    t.boolean  "validated",                default: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "heading_translations", force: :cascade do |t|
    t.integer  "heading_id", limit: 4,     null: false
    t.string   "locale",     limit: 255,   null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "content",    limit: 65535
  end

  add_index "heading_translations", ["heading_id"], name: "index_heading_translations_on_heading_id", using: :btree
  add_index "heading_translations", ["locale"], name: "index_heading_translations_on_locale", using: :btree

  create_table "headings", force: :cascade do |t|
    t.text     "content",          limit: 65535
    t.integer  "headingable_id",   limit: 4
    t.string   "headingable_type", limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "headings", ["headingable_type", "headingable_id"], name: "index_headings_on_headingable_type_and_headingable_id", using: :btree

  create_table "links", force: :cascade do |t|
    t.integer  "linkable_id",   limit: 4
    t.string   "linkable_type", limit: 255
    t.string   "url",           limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "links", ["linkable_type", "linkable_id"], name: "index_links_on_linkable_type_and_linkable_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.integer  "locationable_id",   limit: 4
    t.string   "locationable_type", limit: 255
    t.string   "address",           limit: 255
    t.string   "city",              limit: 255
    t.string   "postcode",          limit: 255
    t.float    "latitude",          limit: 24
    t.float    "longitude",         limit: 24
    t.string   "geocode_address",   limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "locations", ["locationable_type", "locationable_id"], name: "index_locations_on_locationable_type_and_locationable_id", using: :btree

  create_table "mailing_message_translations", force: :cascade do |t|
    t.integer  "mailing_message_id", limit: 4,     null: false
    t.string   "locale",             limit: 255,   null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "title",              limit: 255
    t.text     "content",            limit: 65535
  end

  add_index "mailing_message_translations", ["locale"], name: "index_mailing_message_translations_on_locale", using: :btree
  add_index "mailing_message_translations", ["mailing_message_id"], name: "index_mailing_message_translations_on_mailing_message_id", using: :btree

  create_table "mailing_message_users", force: :cascade do |t|
    t.integer "mailing_user_id",    limit: 4
    t.integer "mailing_message_id", limit: 4
  end

  add_index "mailing_message_users", ["mailing_message_id"], name: "index_mailing_message_users_on_mailing_message_id", using: :btree
  add_index "mailing_message_users", ["mailing_user_id"], name: "index_mailing_message_users_on_mailing_user_id", using: :btree

  create_table "mailing_messages", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.text     "content",        limit: 65535
    t.boolean  "show_signature",               default: true
    t.datetime "sent_at"
    t.string   "token",          limit: 255
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "mailing_setting_translations", force: :cascade do |t|
    t.integer  "mailing_setting_id",  limit: 4,     null: false
    t.string   "locale",              limit: 255,   null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.text     "signature",           limit: 65535
    t.string   "unsubscribe_title",   limit: 255
    t.text     "unsubscribe_content", limit: 65535
  end

  add_index "mailing_setting_translations", ["locale"], name: "index_mailing_setting_translations_on_locale", using: :btree
  add_index "mailing_setting_translations", ["mailing_setting_id"], name: "index_mailing_setting_translations_on_mailing_setting_id", using: :btree

  create_table "mailing_settings", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "email",               limit: 255
    t.text     "signature",           limit: 65535
    t.string   "unsubscribe_title",   limit: 255
    t.text     "unsubscribe_content", limit: 65535
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "mailing_users", force: :cascade do |t|
    t.string   "fullname",   limit: 255
    t.string   "email",      limit: 255
    t.string   "token",      limit: 255
    t.string   "lang",       limit: 255
    t.boolean  "archive",                default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "map_settings", force: :cascade do |t|
    t.string   "marker_icon",  limit: 255
    t.string   "marker_color", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "menu_translations", force: :cascade do |t|
    t.integer  "menu_id",    limit: 4,   null: false
    t.string   "locale",     limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "title",      limit: 255
  end

  add_index "menu_translations", ["locale"], name: "index_menu_translations_on_locale", using: :btree
  add_index "menu_translations", ["menu_id"], name: "index_menu_translations_on_menu_id", using: :btree

  create_table "menus", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.boolean  "online",                     default: true
    t.boolean  "show_in_header",             default: true
    t.boolean  "show_in_footer",             default: false
    t.string   "ancestry",       limit: 255
    t.integer  "position",       limit: 4
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  create_table "newsletter_setting_translations", force: :cascade do |t|
    t.integer  "newsletter_setting_id", limit: 4,     null: false
    t.string   "locale",                limit: 255,   null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "title_subscriber",      limit: 255
    t.text     "content_subscriber",    limit: 65535
  end

  add_index "newsletter_setting_translations", ["locale"], name: "index_newsletter_setting_translations_on_locale", using: :btree
  add_index "newsletter_setting_translations", ["newsletter_setting_id"], name: "index_newsletter_setting_translations_on_newsletter_setting_id", using: :btree

  create_table "newsletter_settings", force: :cascade do |t|
    t.boolean  "send_welcome_email",               default: true
    t.string   "title_subscriber",   limit: 255
    t.text     "content_subscriber", limit: 65535
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  create_table "newsletter_translations", force: :cascade do |t|
    t.integer  "newsletter_id", limit: 4,     null: false
    t.string   "locale",        limit: 255,   null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "title",         limit: 255
    t.text     "content",       limit: 65535
  end

  add_index "newsletter_translations", ["locale"], name: "index_newsletter_translations_on_locale", using: :btree
  add_index "newsletter_translations", ["newsletter_id"], name: "index_newsletter_translations_on_newsletter_id", using: :btree

  create_table "newsletter_user_role_translations", force: :cascade do |t|
    t.integer  "newsletter_user_role_id", limit: 4,   null: false
    t.string   "locale",                  limit: 255, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "title",                   limit: 255
  end

  add_index "newsletter_user_role_translations", ["locale"], name: "index_newsletter_user_role_translations_on_locale", using: :btree
  add_index "newsletter_user_role_translations", ["newsletter_user_role_id"], name: "index_eda908bed34c8eafcfa35f3b63d6111221f532d2", using: :btree

  create_table "newsletter_user_roles", force: :cascade do |t|
    t.integer  "rollable_id",   limit: 4
    t.string   "rollable_type", limit: 255
    t.string   "title",         limit: 255
    t.string   "kind",          limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "newsletter_user_roles", ["rollable_type", "rollable_id"], name: "index_newsletter_user_roles_on_rollable_type_and_rollable_id", using: :btree

  create_table "newsletter_users", force: :cascade do |t|
    t.string   "email",                   limit: 255
    t.string   "lang",                    limit: 255, default: "fr"
    t.string   "token",                   limit: 255
    t.integer  "newsletter_user_role_id", limit: 4
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "newsletter_users", ["email"], name: "index_newsletter_users_on_email", unique: true, using: :btree
  add_index "newsletter_users", ["newsletter_user_role_id"], name: "index_newsletter_users_on_newsletter_user_role_id", using: :btree

  create_table "newsletters", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "slug",       limit: 255
    t.text     "content",    limit: 65535
    t.datetime "sent_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "optional_modules", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.boolean  "enabled",                   default: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "picture_translations", force: :cascade do |t|
    t.integer  "picture_id",  limit: 4,     null: false
    t.string   "locale",      limit: 255,   null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
  end

  add_index "picture_translations", ["locale"], name: "index_picture_translations_on_locale", using: :btree
  add_index "picture_translations", ["picture_id"], name: "index_picture_translations_on_picture_id", using: :btree

  create_table "pictures", force: :cascade do |t|
    t.integer  "attachable_id",      limit: 4
    t.string   "attachable_type",    limit: 255
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.string   "title",              limit: 255
    t.text     "description",        limit: 65535
    t.text     "retina_dimensions",  limit: 65535
    t.boolean  "primary",                          default: false
    t.integer  "position",           limit: 4
    t.boolean  "online",                           default: true
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "pictures", ["attachable_type", "attachable_id"], name: "index_pictures_on_attachable_type_and_attachable_id", using: :btree

  create_table "post_translations", force: :cascade do |t|
    t.integer  "post_id",    limit: 4,     null: false
    t.string   "locale",     limit: 255,   null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "title",      limit: 255
    t.string   "slug",       limit: 255
    t.text     "content",    limit: 65535
  end

  add_index "post_translations", ["locale"], name: "index_post_translations_on_locale", using: :btree
  add_index "post_translations", ["post_id"], name: "index_post_translations_on_post_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "type",            limit: 255
    t.string   "title",           limit: 255
    t.string   "slug",            limit: 255
    t.text     "content",         limit: 65535
    t.boolean  "show_as_gallery",               default: false
    t.boolean  "allow_comments",                default: true
    t.boolean  "online",                        default: true
    t.integer  "position",        limit: 4
    t.integer  "user_id",         limit: 4
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "posts", ["slug"], name: "index_posts_on_slug", unique: true, using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "referencement_translations", force: :cascade do |t|
    t.integer  "referencement_id", limit: 4,     null: false
    t.string   "locale",           limit: 255,   null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "title",            limit: 255
    t.text     "description",      limit: 65535
    t.string   "keywords",         limit: 255
  end

  add_index "referencement_translations", ["locale"], name: "index_referencement_translations_on_locale", using: :btree
  add_index "referencement_translations", ["referencement_id"], name: "index_referencement_translations_on_referencement_id", using: :btree

  create_table "referencements", force: :cascade do |t|
    t.integer  "attachable_id",   limit: 4
    t.string   "attachable_type", limit: 255
    t.string   "title",           limit: 255
    t.text     "description",     limit: 65535
    t.string   "keywords",        limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "referencements", ["attachable_type", "attachable_id"], name: "index_referencements_on_attachable_type_and_attachable_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "setting_translations", force: :cascade do |t|
    t.integer  "setting_id", limit: 4,   null: false
    t.string   "locale",     limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "title",      limit: 255
    t.string   "subtitle",   limit: 255
  end

  add_index "setting_translations", ["locale"], name: "index_setting_translations_on_locale", using: :btree
  add_index "setting_translations", ["setting_id"], name: "index_setting_translations_on_setting_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "name",                     limit: 255
    t.string   "title",                    limit: 255
    t.string   "subtitle",                 limit: 255
    t.string   "phone",                    limit: 255
    t.string   "phone_secondary",          limit: 255
    t.string   "email",                    limit: 255
    t.integer  "per_page",                 limit: 4,     default: 3
    t.boolean  "show_breadcrumb",                        default: false
    t.boolean  "show_social",                            default: true
    t.boolean  "show_qrcode",                            default: false
    t.boolean  "show_map",                               default: false
    t.boolean  "show_admin_bar",                         default: true
    t.integer  "date_format",              limit: 4,     default: 0
    t.boolean  "maintenance",                            default: false
    t.datetime "logo_updated_at"
    t.integer  "logo_file_size",           limit: 4
    t.string   "logo_content_type",        limit: 255
    t.string   "logo_file_name",           limit: 255
    t.datetime "logo_footer_updated_at"
    t.integer  "logo_footer_file_size",    limit: 4
    t.string   "logo_footer_content_type", limit: 255
    t.string   "logo_footer_file_name",    limit: 255
    t.text     "retina_dimensions",        limit: 65535
    t.string   "twitter_username",         limit: 255
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
  end

  create_table "slide_translations", force: :cascade do |t|
    t.integer  "slide_id",    limit: 4,     null: false
    t.string   "locale",      limit: 255,   null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
  end

  add_index "slide_translations", ["locale"], name: "index_slide_translations_on_locale", using: :btree
  add_index "slide_translations", ["slide_id"], name: "index_slide_translations_on_slide_id", using: :btree

  create_table "sliders", force: :cascade do |t|
    t.string   "animate",      limit: 255
    t.boolean  "autoplay",                 default: true
    t.integer  "time_to_show", limit: 4,   default: 5000
    t.boolean  "hover_pause",              default: true
    t.boolean  "loop",                     default: true
    t.boolean  "navigation",               default: false
    t.boolean  "bullet",                   default: false
    t.boolean  "online",                   default: true
    t.integer  "category_id",  limit: 4
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "sliders", ["category_id"], name: "index_sliders_on_category_id", using: :btree

  create_table "slides", force: :cascade do |t|
    t.integer  "attachable_id",      limit: 4
    t.string   "attachable_type",    limit: 255
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.string   "title",              limit: 255
    t.text     "description",        limit: 65535
    t.text     "retina_dimensions",  limit: 65535
    t.boolean  "primary",                          default: false
    t.integer  "position",           limit: 4
    t.boolean  "online",                           default: true
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "slides", ["attachable_type", "attachable_id"], name: "index_slides_on_attachable_type_and_attachable_id", using: :btree

  create_table "social_connect_settings", force: :cascade do |t|
    t.boolean  "enabled",    default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "social_providers", force: :cascade do |t|
    t.string   "name",                      limit: 255
    t.boolean  "enabled",                               default: true
    t.integer  "social_connect_setting_id", limit: 4
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "social_providers", ["social_connect_setting_id"], name: "index_social_providers_on_social_connect_setting_id", using: :btree

  create_table "socials", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.string   "link",              limit: 255
    t.string   "kind",              limit: 255
    t.boolean  "enabled",                         default: true
    t.datetime "ikon_updated_at"
    t.integer  "ikon_file_size",    limit: 4
    t.string   "ikon_content_type", limit: 255
    t.string   "ikon_file_name",    limit: 255
    t.text     "retina_dimensions", limit: 65535
    t.string   "font_ikon",         limit: 255
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "string_box_translations", force: :cascade do |t|
    t.integer  "string_box_id", limit: 4,     null: false
    t.string   "locale",        limit: 255,   null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "title",         limit: 255
    t.text     "content",       limit: 65535
  end

  add_index "string_box_translations", ["locale"], name: "index_string_box_translations_on_locale", using: :btree
  add_index "string_box_translations", ["string_box_id"], name: "index_string_box_translations_on_string_box_id", using: :btree

  create_table "string_boxes", force: :cascade do |t|
    t.string   "key",                limit: 255
    t.text     "description",        limit: 65535
    t.string   "title",              limit: 255
    t.text     "content",            limit: 65535
    t.integer  "optional_module_id", limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "string_boxes", ["key"], name: "index_string_boxes_on_key", using: :btree
  add_index "string_boxes", ["optional_module_id"], name: "index_string_boxes_on_optional_module_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,   default: "", null: false
    t.string   "username",               limit: 255
    t.string   "slug",                   limit: 255
    t.string   "encrypted_password",     limit: 255,   default: "", null: false
    t.integer  "role_id",                limit: 4,     default: 3,  null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "avatar_file_name",       limit: 255
    t.text     "retina_dimensions",      limit: 65535
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size",       limit: 4
    t.datetime "avatar_updated_at"
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree

  create_table "video_platform_translations", force: :cascade do |t|
    t.integer  "video_platform_id", limit: 4,     null: false
    t.string   "locale",            limit: 255,   null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "title",             limit: 255
    t.text     "description",       limit: 65535
  end

  add_index "video_platform_translations", ["locale"], name: "index_video_platform_translations_on_locale", using: :btree
  add_index "video_platform_translations", ["video_platform_id"], name: "index_video_platform_translations_on_video_platform_id", using: :btree

  create_table "video_platforms", force: :cascade do |t|
    t.integer  "videoable_id",        limit: 4
    t.string   "videoable_type",      limit: 255
    t.string   "url",                 limit: 255
    t.boolean  "native_informations",             default: false
    t.boolean  "online",                          default: true
    t.integer  "position",            limit: 4
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "video_platforms", ["videoable_type", "videoable_id"], name: "index_video_platforms_on_videoable_type_and_videoable_id", using: :btree

  create_table "video_settings", force: :cascade do |t|
    t.boolean  "video_platform",     default: true
    t.boolean  "video_upload",       default: true
    t.boolean  "video_background",   default: false
    t.boolean  "turn_off_the_light", default: true
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "video_subtitles", force: :cascade do |t|
    t.integer  "subtitleable_id",          limit: 4
    t.string   "subtitleable_type",        limit: 255
    t.boolean  "online",                               default: true
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "subtitle_fr_file_name",    limit: 255
    t.string   "subtitle_fr_content_type", limit: 255
    t.integer  "subtitle_fr_file_size",    limit: 4
    t.datetime "subtitle_fr_updated_at"
    t.string   "subtitle_en_file_name",    limit: 255
    t.string   "subtitle_en_content_type", limit: 255
    t.integer  "subtitle_en_file_size",    limit: 4
    t.datetime "subtitle_en_updated_at"
  end

  add_index "video_subtitles", ["subtitleable_type", "subtitleable_id"], name: "index_video_subtitles_on_subtitleable_type_and_subtitleable_id", using: :btree

  create_table "video_upload_translations", force: :cascade do |t|
    t.integer  "video_upload_id", limit: 4,     null: false
    t.string   "locale",          limit: 255,   null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "title",           limit: 255
    t.text     "description",     limit: 65535
  end

  add_index "video_upload_translations", ["locale"], name: "index_video_upload_translations_on_locale", using: :btree
  add_index "video_upload_translations", ["video_upload_id"], name: "index_video_upload_translations_on_video_upload_id", using: :btree

  create_table "video_uploads", force: :cascade do |t|
    t.integer  "videoable_id",            limit: 4
    t.string   "videoable_type",          limit: 255
    t.boolean  "online",                                default: true
    t.integer  "position",                limit: 4
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "video_file_file_name",    limit: 255
    t.string   "video_file_content_type", limit: 255
    t.integer  "video_file_file_size",    limit: 4
    t.datetime "video_file_updated_at"
    t.boolean  "video_file_processing"
    t.text     "retina_dimensions",       limit: 65535
    t.boolean  "video_autoplay",                        default: false
    t.boolean  "video_loop",                            default: false
    t.boolean  "video_controls",                        default: true
    t.boolean  "video_mute",                            default: false
  end

  add_index "video_uploads", ["videoable_type", "videoable_id"], name: "index_video_uploads_on_videoable_type_and_videoable_id", using: :btree

  add_foreign_key "blogs", "blog_categories"
  add_foreign_key "event_settings", "event_orders"
end
