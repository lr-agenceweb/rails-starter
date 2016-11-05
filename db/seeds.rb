# frozen_string_literal: true

# Variables
@locales = I18n.available_locales
@tmp_path = Rails.root.join('public', 'tmp')
FileUtils::mkdir_p @tmp_path
Faker::Config.locale = 'fr'

# Functions
require_relative 'seeds/functions'

# Reset
require_relative 'seeds/reset'

# Users
require_relative 'seeds/users/user_roles'
require_relative 'seeds/users/users'

# Settings
require_relative 'seeds/settings'

# Menu items and pages
require_relative 'seeds/optional_modules'
require_relative 'seeds/core/menus'
require_relative 'seeds/core/pages'

# Posts
require_relative 'seeds/posts/legal_notices'
require_relative 'seeds/posts/connections'
require_relative 'seeds/posts/homes'
require_relative 'seeds/posts/abouts'

#
# Modules
#

# Settings
require_relative 'seeds/map_settings'
require_relative 'seeds/optional_modules/blogs/blog_settings'
require_relative 'seeds/optional_modules/comments/comment_settings'
require_relative 'seeds/optional_modules/events/event_orders'
require_relative 'seeds/optional_modules/events/event_settings'
require_relative 'seeds/optional_modules/mailings/mailing_settings'
require_relative 'seeds/optional_modules/guest_books/guest_book_settings'
require_relative 'seeds/optional_modules/videos/video_settings'
require_relative 'seeds/optional_modules/newsletters/newsletter_settings'
require_relative 'seeds/optional_modules/socials/social_connect_settings'
require_relative 'seeds/optional_modules/adults/adult_settings'

# Blogs
require_relative 'seeds/optional_modules/blogs/blog_categories'
require_relative 'seeds/optional_modules/blogs/blog_articles'

# Comments
require_relative 'seeds/optional_modules/comments/comments'

# Events
require_relative 'seeds/optional_modules/events/event_articles'

# Newsletters
require_relative 'seeds/optional_modules/newsletters/newsletter_user_roles'
require_relative 'seeds/optional_modules/newsletters/newsletter_users'
require_relative 'seeds/optional_modules/newsletters/newsletters'

# Mailings
require_relative 'seeds/optional_modules/mailings/mailing_users'
require_relative 'seeds/optional_modules/mailings/mailing_messages'

# GuestBooks
require_relative 'seeds/optional_modules/guest_books/guest_book_articles'

# Sliders
require_relative 'seeds/optional_modules/sliders/sliders'

# Socials
require_relative 'seeds/optional_modules/socials/social_providers'
require_relative 'seeds/optional_modules/socials/socials'

# Content
require_relative 'seeds/optional_modules/string_boxes/string_boxes'

#
# == FriendlyId
#
puts 'Setting Friendly Id'
User.find_each(&:save)
Post.find_each(&:save)
Blog.find_each(&:save)
BlogCategory.find_each(&:save)
Event.find_each(&:save)

# Cleanup
FileUtils.rm_rf(@tmp_path)

puts 'Seeds successfuly loaded :)'
