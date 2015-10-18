# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Activeadmin assets
Rails.application.config.assets.precompile += %w( active_admin/active_admin_globalize.css )
Rails.application.config.assets.precompile += %w( active_admin/active_admin_globalize.js )

# Mapbox assets
Rails.application.config.assets.precompile += %w( icons-*.png )

# Email and Newsletter assets
Rails.application.config.assets.precompile += %w( email.css newsletter.css )

# Videojs assets
Rails.application.config.assets.precompile += %w( video-js.swf vjs.eot vjs.svg vjs.ttf vjs.woff )
