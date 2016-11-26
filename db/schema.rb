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

ActiveRecord::Schema.define(version: 20161118125419) do

  create_table "adult_setting_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "adult_setting_id",               null: false
    t.string   "locale",                         null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "title"
    t.text     "content",          limit: 65535
    t.index ["adult_setting_id"], name: "index_adult_setting_translations_on_adult_setting_id", using: :btree
    t.index ["locale"], name: "index_adult_setting_translations_on_locale", using: :btree
  end

  create_table "adult_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "redirect_link"
    t.boolean  "enabled",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "audios", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "audioable_type"
    t.integer  "audioable_id"
    t.string   "audio_file_name"
    t.string   "audio_content_type"
    t.integer  "audio_file_size"
    t.datetime "audio_updated_at"
    t.boolean  "audio_autoplay",     default: false
    t.boolean  "online",             default: true
    t.boolean  "audio_processing",   default: true
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["audioable_type", "audioable_id"], name: "index_audios_on_audioable_type_and_audioable_id", using: :btree
  end

  create_table "backgrounds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "retina_dimensions",  limit: 65535
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["attachable_type", "attachable_id"], name: "index_backgrounds_on_attachable_type_and_attachable_id", using: :btree
  end

  create_table "blog_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "slug"
    t.integer  "blogs_count", default: 0, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "blog_category_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "blog_category_id", null: false
    t.string   "locale",           null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "name"
    t.string   "slug"
    t.index ["blog_category_id"], name: "index_blog_category_translations_on_blog_category_id", using: :btree
    t.index ["locale"], name: "index_blog_category_translations_on_locale", using: :btree
  end

  create_table "blog_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "prev_next",          default: false
    t.boolean  "show_last_posts",    default: true
    t.boolean  "show_categories",    default: true
    t.boolean  "show_last_comments", default: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "blog_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "blog_id",                  null: false
    t.string   "locale",                   null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "title"
    t.string   "slug"
    t.text     "content",    limit: 65535
    t.index ["blog_id"], name: "index_blog_translations_on_blog_id", using: :btree
    t.index ["locale"], name: "index_blog_translations_on_locale", using: :btree
  end

  create_table "blogs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "slug"
    t.boolean  "show_as_gallery",  default: false
    t.boolean  "allow_comments",   default: true
    t.boolean  "online",           default: true
    t.integer  "user_id"
    t.integer  "blog_category_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["blog_category_id"], name: "index_blogs_on_blog_category_id", using: :btree
    t.index ["slug"], name: "index_blogs_on_slug", using: :btree
    t.index ["user_id"], name: "index_blogs_on_user_id", using: :btree
  end

  create_table "comment_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "should_signal",   default: true
    t.boolean  "send_email",      default: false
    t.boolean  "should_validate", default: true
    t.boolean  "allow_reply",     default: true
    t.boolean  "emoticons",       default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.string   "username"
    t.string   "email"
    t.text     "comment",          limit: 65535
    t.string   "token"
    t.string   "lang"
    t.boolean  "validated",                      default: false
    t.boolean  "signalled",                      default: false
    t.string   "ancestry"
    t.integer  "user_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.index ["ancestry"], name: "index_comments_on_ancestry", using: :btree
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "locale"
    t.integer  "priority",                 default: 0, null: false
    t.integer  "attempts",                 default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "longtext",   limit: 65535
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
    t.index ["queue"], name: "delayed_jobs_queue", using: :btree
  end

  create_table "event_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "key"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "event_order_id"
    t.boolean  "prev_next",      default: false
    t.boolean  "show_calendar",  default: false
    t.boolean  "show_map",       default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["event_order_id"], name: "index_event_settings_on_event_order_id", using: :btree
  end

  create_table "event_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "event_id",                 null: false
    t.string   "locale",                   null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "title"
    t.string   "slug"
    t.text     "content",    limit: 65535
    t.index ["event_id"], name: "index_event_translations_on_event_id", using: :btree
    t.index ["locale"], name: "index_event_translations_on_locale", using: :btree
  end

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "slug"
    t.boolean  "all_day",         default: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "show_as_gallery", default: false
    t.boolean  "show_calendar",   default: false
    t.boolean  "show_map",        default: false
    t.boolean  "online",          default: true
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["slug"], name: "index_events_on_slug", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "guest_book_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "should_validate", default: true
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "guest_books", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "username",                                 null: false
    t.string   "email",                                    null: false
    t.text     "content",    limit: 65535,                 null: false
    t.string   "lang",                                     null: false
    t.boolean  "validated",                default: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "heading_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "heading_id",               null: false
    t.string   "locale",                   null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "content",    limit: 65535
    t.index ["heading_id"], name: "index_heading_translations_on_heading_id", using: :btree
    t.index ["locale"], name: "index_heading_translations_on_locale", using: :btree
  end

  create_table "headings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "headingable_type"
    t.integer  "headingable_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["headingable_type", "headingable_id"], name: "index_headings_on_headingable_type_and_headingable_id", using: :btree
  end

  create_table "links", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "linkable_type"
    t.integer  "linkable_id"
    t.string   "url"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["linkable_type", "linkable_id"], name: "index_links_on_linkable_type_and_linkable_id", using: :btree
  end

  create_table "locations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "locationable_type"
    t.integer  "locationable_id"
    t.string   "address"
    t.string   "city"
    t.string   "postcode"
    t.float    "latitude",          limit: 24
    t.float    "longitude",         limit: 24
    t.string   "geocode_address"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["locationable_type", "locationable_id"], name: "index_locations_on_locationable_type_and_locationable_id", using: :btree
  end

  create_table "mailing_message_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "mailing_message_id",               null: false
    t.string   "locale",                           null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "title"
    t.text     "content",            limit: 65535
    t.index ["locale"], name: "index_mailing_message_translations_on_locale", using: :btree
    t.index ["mailing_message_id"], name: "index_mailing_message_translations_on_mailing_message_id", using: :btree
  end

  create_table "mailing_message_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "mailing_user_id"
    t.integer "mailing_message_id"
    t.index ["mailing_message_id"], name: "index_mailing_message_users_on_mailing_message_id", using: :btree
    t.index ["mailing_user_id"], name: "index_mailing_message_users_on_mailing_user_id", using: :btree
  end

  create_table "mailing_messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "show_signature", default: true
    t.datetime "sent_at"
    t.string   "token"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "mailing_setting_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "mailing_setting_id",                null: false
    t.string   "locale",                            null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.text     "signature",           limit: 65535
    t.string   "unsubscribe_title"
    t.text     "unsubscribe_content", limit: 65535
    t.index ["locale"], name: "index_mailing_setting_translations_on_locale", using: :btree
    t.index ["mailing_setting_id"], name: "index_mailing_setting_translations_on_mailing_setting_id", using: :btree
  end

  create_table "mailing_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mailing_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "fullname"
    t.string   "email"
    t.string   "token"
    t.string   "lang"
    t.boolean  "archive",    default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "map_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "marker_icon"
    t.string   "marker_color"
    t.boolean  "show_map",     default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "menu_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "menu_id",    null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "title"
    t.index ["locale"], name: "index_menu_translations_on_locale", using: :btree
    t.index ["menu_id"], name: "index_menu_translations_on_menu_id", using: :btree
  end

  create_table "menus", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "online",         default: true
    t.boolean  "show_in_header", default: true
    t.boolean  "show_in_footer", default: false
    t.string   "ancestry"
    t.integer  "position"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "newsletter_setting_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "newsletter_setting_id",               null: false
    t.string   "locale",                              null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "title_subscriber"
    t.text     "content_subscriber",    limit: 65535
    t.index ["locale"], name: "index_newsletter_setting_translations_on_locale", using: :btree
    t.index ["newsletter_setting_id"], name: "index_newsletter_setting_translations_on_newsletter_setting_id", using: :btree
  end

  create_table "newsletter_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "send_welcome_email", default: true
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "newsletter_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "newsletter_id",               null: false
    t.string   "locale",                      null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "title"
    t.text     "content",       limit: 65535
    t.index ["locale"], name: "index_newsletter_translations_on_locale", using: :btree
    t.index ["newsletter_id"], name: "index_newsletter_translations_on_newsletter_id", using: :btree
  end

  create_table "newsletter_user_role_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "newsletter_user_role_id", null: false
    t.string   "locale",                  null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "title"
    t.index ["locale"], name: "index_newsletter_user_role_translations_on_locale", using: :btree
    t.index ["newsletter_user_role_id"], name: "index_eda908bed34c8eafcfa35f3b63d6111221f532d2", using: :btree
  end

  create_table "newsletter_user_roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "rollable_type"
    t.integer  "rollable_id"
    t.string   "kind"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["rollable_type", "rollable_id"], name: "index_newsletter_user_roles_on_rollable_type_and_rollable_id", using: :btree
  end

  create_table "newsletter_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email"
    t.string   "lang",                    default: "fr"
    t.string   "token"
    t.integer  "newsletter_user_role_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["email"], name: "index_newsletter_users_on_email", unique: true, using: :btree
    t.index ["newsletter_user_role_id"], name: "index_newsletter_users_on_newsletter_user_role_id", using: :btree
  end

  create_table "newsletters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "slug"
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "optional_modules", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "description", limit: 65535
    t.boolean  "enabled",                   default: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "pages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "color"
    t.boolean  "optional",           default: false
    t.integer  "optional_module_id"
    t.integer  "menu_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["menu_id"], name: "index_pages_on_menu_id", using: :btree
    t.index ["optional_module_id"], name: "index_pages_on_optional_module_id", using: :btree
  end

  create_table "picture_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "picture_id",                null: false
    t.string   "locale",                    null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "title"
    t.text     "description", limit: 65535
    t.index ["locale"], name: "index_picture_translations_on_locale", using: :btree
    t.index ["picture_id"], name: "index_picture_translations_on_picture_id", using: :btree
  end

  create_table "pictures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "retina_dimensions",  limit: 65535
    t.boolean  "primary",                          default: false
    t.integer  "position"
    t.boolean  "online",                           default: true
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.index ["attachable_type", "attachable_id"], name: "index_pictures_on_attachable_type_and_attachable_id", using: :btree
  end

  create_table "post_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "post_id",                  null: false
    t.string   "locale",                   null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "title"
    t.string   "slug"
    t.text     "content",    limit: 65535
    t.index ["locale"], name: "index_post_translations_on_locale", using: :btree
    t.index ["post_id"], name: "index_post_translations_on_post_id", using: :btree
  end

  create_table "posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "type"
    t.string   "slug"
    t.boolean  "show_as_gallery", default: false
    t.boolean  "allow_comments",  default: true
    t.boolean  "online",          default: true
    t.integer  "position"
    t.integer  "user_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["slug"], name: "index_posts_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_posts_on_user_id", using: :btree
  end

  create_table "publication_dates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "publishable_type"
    t.integer  "publishable_id"
    t.boolean  "published_later",     default: false
    t.boolean  "expired_prematurely", default: false
    t.datetime "published_at"
    t.datetime "expired_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["publishable_type", "publishable_id"], name: "index_publication_dates_on_publishable_type_and_publishable_id", using: :btree
  end

  create_table "referencement_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "referencement_id",               null: false
    t.string   "locale",                         null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "title"
    t.text     "description",      limit: 65535
    t.string   "keywords"
    t.index ["locale"], name: "index_referencement_translations_on_locale", using: :btree
    t.index ["referencement_id"], name: "index_referencement_translations_on_referencement_id", using: :btree
  end

  create_table "referencements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["attachable_type", "attachable_id"], name: "index_referencements_on_attachable_type_and_attachable_id", using: :btree
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "setting_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "setting_id", null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "title"
    t.string   "subtitle"
    t.index ["locale"], name: "index_setting_translations_on_locale", using: :btree
    t.index ["setting_id"], name: "index_setting_translations_on_setting_id", using: :btree
  end

  create_table "settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "phone_secondary"
    t.string   "email"
    t.integer  "per_page",                               default: 3
    t.boolean  "show_breadcrumb",                        default: false
    t.boolean  "show_social",                            default: true
    t.boolean  "show_qrcode",                            default: false
    t.boolean  "show_admin_bar",                         default: true
    t.boolean  "show_file_upload",                       default: false
    t.boolean  "answering_machine",                      default: false
    t.boolean  "picture_in_picture",                     default: true
    t.integer  "date_format",                            default: 0
    t.boolean  "maintenance",                            default: false
    t.datetime "logo_updated_at"
    t.integer  "logo_file_size"
    t.string   "logo_content_type"
    t.string   "logo_file_name"
    t.datetime "logo_footer_updated_at"
    t.integer  "logo_footer_file_size"
    t.string   "logo_footer_content_type"
    t.string   "logo_footer_file_name"
    t.text     "retina_dimensions",        limit: 65535
    t.string   "twitter_username"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
  end

  create_table "slide_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "slide_id",                  null: false
    t.string   "locale",                    null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "title"
    t.text     "description", limit: 65535
    t.index ["locale"], name: "index_slide_translations_on_locale", using: :btree
    t.index ["slide_id"], name: "index_slide_translations_on_slide_id", using: :btree
  end

  create_table "sliders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "animate"
    t.boolean  "autoplay",     default: true
    t.integer  "time_to_show", default: 5000
    t.boolean  "hover_pause",  default: true
    t.boolean  "loop",         default: true
    t.boolean  "navigation",   default: false
    t.boolean  "bullet",       default: false
    t.boolean  "online",       default: true
    t.integer  "page_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["page_id"], name: "index_sliders_on_page_id", using: :btree
  end

  create_table "slides", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "retina_dimensions",  limit: 65535
    t.boolean  "primary",                          default: false
    t.integer  "position"
    t.boolean  "online",                           default: true
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.index ["attachable_type", "attachable_id"], name: "index_slides_on_attachable_type_and_attachable_id", using: :btree
  end

  create_table "social_connect_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "enabled",    default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "social_providers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.boolean  "enabled",                   default: true
    t.integer  "social_connect_setting_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["social_connect_setting_id"], name: "index_social_providers_on_social_connect_setting_id", using: :btree
  end

  create_table "socials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.string   "link"
    t.string   "kind"
    t.boolean  "enabled",                         default: true
    t.datetime "ikon_updated_at"
    t.integer  "ikon_file_size"
    t.string   "ikon_content_type"
    t.string   "ikon_file_name"
    t.text     "retina_dimensions", limit: 65535
    t.string   "font_ikon"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "string_box_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "string_box_id",               null: false
    t.string   "locale",                      null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "title"
    t.text     "content",       limit: 65535
    t.index ["locale"], name: "index_string_box_translations_on_locale", using: :btree
    t.index ["string_box_id"], name: "index_string_box_translations_on_string_box_id", using: :btree
  end

  create_table "string_boxes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "key"
    t.text     "description",        limit: 65535
    t.integer  "optional_module_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["key"], name: "index_string_boxes_on_key", using: :btree
    t.index ["optional_module_id"], name: "index_string_boxes_on_optional_module_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                                default: "",    null: false
    t.string   "username"
    t.string   "slug"
    t.string   "encrypted_password",                   default: "",    null: false
    t.integer  "role_id",                              default: 3,     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.string   "avatar_file_name"
    t.text     "retina_dimensions",      limit: 65535
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "provider"
    t.string   "uid"
    t.boolean  "account_active",                       default: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["role_id"], name: "index_users_on_role_id", using: :btree
    t.index ["slug"], name: "index_users_on_slug", using: :btree
  end

  create_table "video_platform_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "video_platform_id",               null: false
    t.string   "locale",                          null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "title"
    t.text     "description",       limit: 65535
    t.index ["locale"], name: "index_video_platform_translations_on_locale", using: :btree
    t.index ["video_platform_id"], name: "index_video_platform_translations_on_video_platform_id", using: :btree
  end

  create_table "video_platforms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "videoable_type"
    t.integer  "videoable_id"
    t.string   "url"
    t.boolean  "native_informations", default: false
    t.boolean  "online",              default: true
    t.integer  "position"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["videoable_type", "videoable_id"], name: "index_video_platforms_on_videoable_type_and_videoable_id", using: :btree
  end

  create_table "video_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "video_platform",     default: true
    t.boolean  "video_upload",       default: true
    t.boolean  "video_background",   default: false
    t.boolean  "turn_off_the_light", default: true
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "video_subtitles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "subtitleable_type"
    t.integer  "subtitleable_id"
    t.boolean  "online",                   default: true
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "subtitle_fr_file_name"
    t.string   "subtitle_fr_content_type"
    t.integer  "subtitle_fr_file_size"
    t.datetime "subtitle_fr_updated_at"
    t.string   "subtitle_en_file_name"
    t.string   "subtitle_en_content_type"
    t.integer  "subtitle_en_file_size"
    t.datetime "subtitle_en_updated_at"
    t.index ["subtitleable_type", "subtitleable_id"], name: "index_video_subtitles_on_subtitleable_type_and_subtitleable_id", using: :btree
  end

  create_table "video_upload_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "video_upload_id",               null: false
    t.string   "locale",                        null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "title"
    t.text     "description",     limit: 65535
    t.index ["locale"], name: "index_video_upload_translations_on_locale", using: :btree
    t.index ["video_upload_id"], name: "index_video_upload_translations_on_video_upload_id", using: :btree
  end

  create_table "video_uploads", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "videoable_type"
    t.integer  "videoable_id"
    t.boolean  "online",                                default: true
    t.boolean  "video_autoplay",                        default: false
    t.boolean  "video_loop",                            default: false
    t.boolean  "video_controls",                        default: true
    t.boolean  "video_mute",                            default: false
    t.integer  "position"
    t.boolean  "video_file_processing",                 default: true
    t.text     "retina_dimensions",       limit: 65535
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "video_file_file_name"
    t.string   "video_file_content_type"
    t.integer  "video_file_file_size"
    t.datetime "video_file_updated_at"
    t.index ["videoable_type", "videoable_id"], name: "index_video_uploads_on_videoable_type_and_videoable_id", using: :btree
  end

  add_foreign_key "blogs", "blog_categories"
  add_foreign_key "event_settings", "event_orders"
end
