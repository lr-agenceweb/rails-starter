# frozen_string_literal: true
# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.1'

# Activeadmin assets
Rails.application.config.assets.precompile += %w( active_admin/active_admin_globalize.css )
Rails.application.config.assets.precompile += %w( active_admin/active_admin_globalize.js )

# Mapbox assets
Rails.application.config.assets.precompile += %w( icons-*.png )

# Email / Newsletter / Maintenance assets
Rails.application.config.assets.precompile += %w( email.css newsletter.css maintenance.css noscript.css )
