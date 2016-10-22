# frozen_string_literal: true

@locales = I18n.available_locales

# Functions
require_relative 'seeds/_files/functions'

# Reset
require_relative 'seeds/_files/reset'

# Users
require_relative 'seeds/_files/users/user_roles'
require_relative 'seeds/_files/users/users'

# Settings
require_relative 'seeds/_files/settings'
require_relative 'seeds/_files/locations'

# Menu items and pages
require_relative 'seeds/_files/optional_modules'
require_relative 'seeds/_files/core/menus'
require_relative 'seeds/_files/core/categories'

# Posts
require_relative 'seeds/_files/posts/legal_notices'
require_relative 'seeds/_files/posts/connections'
require_relative 'seeds/_files/posts/homes'
require_relative 'seeds/_files/posts/abouts'

#
# Modules
#

# Settings
require_relative 'seeds/_files/map_settings'
require_relative 'seeds/_files/optional_modules/blogs/blog_settings'
require_relative 'seeds/_files/optional_modules/comments/comment_settings'
require_relative 'seeds/_files/optional_modules/events/event_orders'
require_relative 'seeds/_files/optional_modules/events/event_settings'
require_relative 'seeds/_files/optional_modules/mailings/mailing_settings'
require_relative 'seeds/_files/optional_modules/guest_books/guest_book_settings'
require_relative 'seeds/_files/optional_modules/videos/video_settings'
require_relative 'seeds/_files/optional_modules/newsletters/newsletter_settings'
require_relative 'seeds/_files/optional_modules/socials/social_connect_settings'
require_relative 'seeds/_files/optional_modules/adults/adult_settings'

# Blogs
require_relative 'seeds/_files/optional_modules/blogs/blog_categories'
require_relative 'seeds/_files/optional_modules/blogs/blog_articles'

# Comments
require_relative 'seeds/_files/optional_modules/comments/comments'

# Events
require_relative 'seeds/_files/optional_modules/events/event_articles'

# Newsletters
require_relative 'seeds/_files/optional_modules/newsletters/newsletter_user_roles'
require_relative 'seeds/_files/optional_modules/newsletters/newsletter_users'
require_relative 'seeds/_files/optional_modules/newsletters/newsletters'

# Mailings
require_relative 'seeds/_files/optional_modules/mailings/mailing_users'
require_relative 'seeds/_files/optional_modules/mailings/mailing_messages'

# GuestBooks
require_relative 'seeds/_files/optional_modules/guest_books/guest_book_articles'

# Sliders
require_relative 'seeds/_files/optional_modules/sliders/sliders'

# Socials
require_relative 'seeds/_files/optional_modules/socials/social_providers'
require_relative 'seeds/_files/optional_modules/socials/socials'

# Content
require_relative 'seeds/_files/optional_modules/string_boxes/string_boxes'

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
['image.jpg', 'audio.mp3', 'video.mp4'].each do |item|
  File.delete(Rails.root.join('public', item))
end

puts 'Seeds successfuly loaded :)'
