# frozen_string_literal: true
source 'https://rubygems.org'

#
# Rails
# =====================
gem 'rails', '4.2.7.1'

#
# Database
# =====================
gem 'mysql2'
gem 'pg'
gem 'sqlite3'
gem 'ancestry'
gem 'database_cleaner'

#
# Authentication
# =====================
gem 'devise', '~> 4.2.0'
gem 'devise-i18n'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2', '~> 0.4.1'

#
# Administration
# =====================
gem 'activeadmin', '1.0.0.pre4'
gem 'activeadmin_addons'
gem 'acts_as_list'
gem 'activeadmin-sortable', github: 'mvdstam/activeadmin-sortable'
gem 'active_skin'

#
# Core enhancement
# =====================
gem 'draper'
gem 'enumerize', '~> 1.1.1'

#
# Html
# =====================
gem 'slim-rails' # slim file
gem 'kaminari', '~> 0.17.0' # Pagination
gem 'gretel' # Breadcrumb
gem 'rails_autolink'
gem 'truncate_html', github: 'AlexGunslinger/truncate_html'
gem 'outdatedbrowser_rails', github: 'anthony-robin/outdatedbrowser_rails'
gem 'vex_rails', github: 'anthony-robin/vex_rails'
gem 'js_cookie_rails'
gem 'fotoramajs'

#
# Calendar
# =====================
gem 'fullcalendar-rails'
gem 'momentjs-rails'
gem 'timecop'

#
# Media upload
# =====================
gem 'paperclip', '~> 5.0'
gem 'retina_rails', '~> 2.0.0'
gem 'paperclip-av-transcoder'
gem 'delayed_paperclip'

#
# Forms and WYSIWYG
# =====================
gem 'simple_form'
gem 'client_side_validations'
gem 'client_side_validations-simple_form'
gem 'rails_autosize_jquery', github: 'lr-agenceweb/rails_autosize_jquery'
gem 'wysiwyg-rails' # Froala editor
gem 'valid_url'
gem 'actionmailer-with-request'

#
# Translation
# =====================
gem 'route_translator'
gem 'globalize', '~> 5.0.0'
gem 'activeadmin-globalize',
    github: 'anthony-robin/activeadmin-globalize',
    branch: 'master'
gem 'rails-i18n',
    github: 'svenfuchs/rails-i18n',
    branch: 'rails-4-x'
gem 'i18n-js', '>= 3.0.0.rc14'

#
# Map
# =====================
gem 'mapbox-rails', github: 'anthony-robin/mapbox-rails'
gem 'gmaps-autocomplete-rails'

#
# SEO
# =====================
gem 'friendly_id', '~> 5.1'
gem 'friendly_id-globalize'
gem 'sitemap_generator'
gem 'meta-tags'

#
# Security
# =====================
gem 'figaro'
gem 'cancancan', '~> 1.10'
gem 'draper-cancancan'
gem 'secure_headers', '~> 3.0'
gem 'open_uri_redirections' # HTTP(S) redirections

#
# Analytics
# =====================
gem 'analytical'

#
# Background Tasks
# =====================
gem 'whenever', require: false # Cron tasks
gem 'daemons'
gem 'delayed_job_active_record'

#
# Email
# =====================
gem 'dkim' # authenticate emails
gem 'inky-rb', require: 'inky' # inky Foundation
gem 'premailer-rails'
gem 'nokogiri'

#
# Assets
# =====================
gem 'sassc-rails'
gem 'autoprefixer-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2.0'
gem 'jquery-ui-rails'
gem 'turbolinks', '~> 2.5.3'
gem 'nprogress-rails'
gem 'foundation-rails', '~> 6.2.0'
gem 'font-awesome-rails'
gem 'jbuilder', '~> 2.0'
gem 'gon'
gem 'gravatar_image_tag'
gem 'magnific-popup-rails', '~> 1.1.0'
gem 'chartkick'
gem 'faker'

#
# Video
# =====================
gem 'mediaelement_rails' # HTML5 video player
gem 'video_info'

#
# Logs
# =====================
gem 'lograge' # cleaner logs

#
# Cache
# =====================
gem 'rails-observers'
gem 'dalli'

group :development do
  gem 'better_errors'
  gem 'rb-fsevent', require: false
  gem 'irbtools', require: 'irbtools/binding'
  gem 'binding_of_caller'
  gem 'railroady' # graph of models
  gem 'shut_up_assets'
  gem 'annotate'

  # Server
  # =====================
  gem 'puma'

  # Debug Rails request in Chrome DevTools
  # =====================
  gem 'meta_request'

  gem 'bullet' # display N+1 db queries
  gem 'shog' # colorize logs

  # Deploy
  # =====================
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rvm'
  gem 'capistrano-rails-collection'
  gem 'capistrano-passenger'
  gem 'capistrano3-delayed-job', '~> 1.0'
  gem 'web-console', '~> 3.0'
end

group :development, :test do
  gem 'byebug'
  gem 'spring', '~> 1.7.0'
end

group :test do
  gem 'minitest'
  gem 'minitest-reporters', require: false
  gem 'mocha'
  gem 'codeclimate-test-reporter', require: nil
  gem 'simplecov', require: false
  gem 'simplecov-json', require: false
  gem 'test_after_commit'
end

group :production, :staging, :backup do
  gem 'exception_notification' # Notify when exceptions raised
  gem 'slack-notifier' # Use slack as Notifier
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0'
end
