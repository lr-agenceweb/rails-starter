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

ActiveRecord::Schema.define(version: 20151002201558) do

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
    t.string   "title",           limit: 255
    t.string   "slug",            limit: 255
    t.text     "content",         limit: 65535
    t.boolean  "allow_comments",                default: true
    t.boolean  "show_as_gallery",               default: false
    t.boolean  "online",                        default: true
    t.integer  "user_id",         limit: 4
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

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

  create_table "comments", force: :cascade do |t|
    t.string   "title",            limit: 50,    default: ""
    t.string   "username",         limit: 255
    t.string   "email",            limit: 255
    t.text     "comment",          limit: 65535
    t.string   "lang",             limit: 255
    t.boolean  "validated",                      default: false
    t.integer  "commentable_id",   limit: 4
    t.string   "commentable_type", limit: 255
    t.integer  "user_id",          limit: 4
    t.string   "role",             limit: 255,   default: "comments"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

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
    t.string   "url",             limit: 255
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

  create_table "locations", force: :cascade do |t|
    t.integer  "locationable_id",   limit: 4
    t.string   "locationable_type", limit: 255
    t.string   "address",           limit: 255
    t.string   "city",              limit: 255
    t.integer  "postcode",          limit: 4
    t.float    "latitude",          limit: 24
    t.float    "longitude",         limit: 24
    t.string   "geocode_address",   limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "locations", ["locationable_type", "locationable_id"], name: "index_locations_on_locationable_type_and_locationable_id", using: :btree

  create_table "maps", force: :cascade do |t|
    t.string   "marker_icon",  limit: 255
    t.string   "marker_color", limit: 255
    t.boolean  "show_map"
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
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "newsletter_user_roles", ["rollable_type", "rollable_id"], name: "index_newsletter_user_roles_on_rollable_type_and_rollable_id", using: :btree

  create_table "newsletter_users", force: :cascade do |t|
    t.string   "email",                   limit: 255
    t.string   "lang",                    limit: 255, default: "fr"
    t.string   "token",                   limit: 255
    t.integer  "newsletter_user_role_id", limit: 4,   default: 1
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
    t.boolean  "show_breadcrumb",                        default: false
    t.boolean  "show_social",                            default: true
    t.boolean  "show_qrcode",                            default: false
    t.boolean  "should_validate",                        default: true
    t.boolean  "maintenance",                            default: false
    t.string   "twitter_username",         limit: 255
    t.datetime "logo_updated_at"
    t.integer  "logo_file_size",           limit: 4
    t.string   "logo_content_type",        limit: 255
    t.string   "logo_file_name",           limit: 255
    t.datetime "logo_footer_updated_at"
    t.integer  "logo_footer_file_size",    limit: 4
    t.string   "logo_footer_content_type", limit: 255
    t.string   "logo_footer_file_name",    limit: 255
    t.text     "retina_dimensions",        limit: 65535
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

  create_table "socials", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.string   "link",              limit: 255
    t.string   "kind",              limit: 255
    t.boolean  "enabled",                         default: true
    t.string   "font_ikon",         limit: 255
    t.datetime "ikon_updated_at"
    t.integer  "ikon_file_size",    limit: 4
    t.string   "ikon_content_type", limit: 255
    t.string   "ikon_file_name",    limit: 255
    t.text     "retina_dimensions", limit: 65535
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
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

  add_foreign_key "categories", "menus", name: "fk_categories_menu_id"
  add_foreign_key "menu_translations", "menus", name: "fk_menu_translations_menu_id"
  add_foreign_key "newsletter_users", "newsletter_user_roles"
  add_foreign_key "string_boxes", "optional_modules"
end
