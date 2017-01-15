# frozen_string_literal: true
source 'https://rubygems.org'

#
# Rails
# =====================
gem 'rails', '5.0.1'
gem 'rails-observers', github: 'rails/rails-observers' # Rails 5 fix
gem 'puma' # Server

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
gem 'activeadmin', github: 'activeadmin'
gem 'inherited_resources', github: 'activeadmin/inherited_resources' # Rails 5 fix

gem 'activeadmin_addons'
gem 'acts_as_list'
gem 'activeadmin-sortable', github: 'mvdstam/activeadmin-sortable'
gem 'active_skin'

#
# Core enhancement
# =====================
gem 'draper', '3.0.0.pre1'
gem 'slim-rails' # slim file
gem 'sassc-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2.0'
gem 'turbolinks',
    github: 'dobtco/turbolinks-classic',
    branch: 'fix-deprecations' # Rails 5 fix (deprecations)
gem 'jbuilder', '~> 2.0'

#
# Media upload
# =====================
gem 'paperclip', '~> 5.0'
gem 'paperclip-av-transcoder'
gem 'delayed_paperclip'

#
# Forms and WYSIWYG
# =====================
gem 'simple_form'
gem 'client_side_validations',
    github: 'DavyJonesLocker/client_side_validations',
    branch: 'rails5' # Rails 5 fix
gem 'client_side_validations-simple_form',
    github: 'DavyJonesLocker/client_side_validations-simple_form',
    branch: 'rails5' # Rails 5 fix
gem 'valid_url'

#
# Translation
# =====================
gem 'route_translator'
gem 'globalize', github: 'globalize/globalize' # Rails 5 fix
gem 'activemodel-serializers-xml' # Rails 5 fix
gem 'rails-i18n', '~> 5.0.0' # Rails 5 fix
gem 'i18n-js', '>= 3.0.0.rc14'

#
# SEO
# =====================
gem 'friendly_id'
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
gem 'daemons'
gem 'delayed-web'
gem 'delayed_job_active_record'
gem 'whenever', require: false # Cron tasks

#
# Email
# =====================
gem 'dkim' # authenticate emails
gem 'inky-rb', require: 'inky' # inky Foundation
gem 'premailer-rails'
gem 'nokogiri'

#
# Frontend libraries
# ====================
gem 'jquery-ui-rails'
gem 'normalize-rails', github: 'markmcconachie/normalize-rails'
gem 'foundation-rails', '~> 6.3.0'
gem 'fotoramajs' # Slider
gem 'fullcalendar-rails' # Calendar
gem 'momentjs-rails'
gem 'wysiwyg-rails' # Froala editor
gem 'mapbox-rails', github: 'aai/mapbox-rails'
gem 'kaminari', '~> 0.17.0' # Pagination
gem 'gretel' # Breadcrumb
gem 'js_cookie_rails'
gem 'autoprefixer-rails'
gem 'nprogress-rails'
gem 'font-awesome-rails'
gem 'gon'
gem 'gravatar_image_tag'
gem 'magnific-popup-rails', '~> 1.1.0'
gem 'chartkick'

#
# Backend libraries
# ===================
gem 'faker'
gem 'timecop'
gem 'rails_autolink'
gem 'truncate_html', github: 'AlexGunslinger/truncate_html'
gem 'gmaps-autocomplete-rails'

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
gem 'dalli'

#
# Own gems fixes (https://github.com/gemsfix)
# ================
gem 'retina_rails',
    github: 'gemsfix/retina_rails',
    branch: 'feature/rails5'
gem 'vex_rails', github: 'anthony-robin/vex_rails'
gem 'activeadmin-globalize', github: 'anthony-robin/activeadmin-globalize'
gem 'outdatedbrowser_rails', github: 'anthony-robin/outdatedbrowser_rails'
gem 'rails_autosize_jquery', github: 'lr-agenceweb/rails_autosize_jquery'

group :development do
  gem 'spring'
  gem 'listen'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'better_errors'
  gem 'web-console', '~> 3.0'

  gem 'rb-fsevent', require: false
  gem 'irbtools', require: 'irbtools/binding'

  gem 'binding_of_caller'
  gem 'railroady' # Graph of models
  gem 'annotate' # Annotate table structure in models

  gem 'shog' # Colorize logs
  gem 'bullet' # Display N+1 db queries
  gem 'meta_request' # Debug Rails request in Chrome DevTools

  # Deployment
  # =====================
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rvm'
  gem 'capistrano-rails-collection'
  gem 'capistrano3-puma'
  gem 'capistrano3-delayed-job', '~> 1.0'
end

group :development, :test do
  gem 'byebug'
end

group :test do
  gem 'minitest-rails'
  gem 'shoulda', '~> 3.5'
  gem 'shoulda-matchers', '~> 2.0'
  gem 'rails-controller-testing'

  # Coverage
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', '~> 1.0.0', require: false
end

group :production, :staging, :backup do
  gem 'slack-notifier' # Use slack as Notifier
  gem 'exception_notification' # Notify when exceptions raised
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0'
end
