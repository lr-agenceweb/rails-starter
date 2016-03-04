source 'https://rubygems.org'

#
# == Rails
#
gem 'rails', '4.2.5.2'
gem 'sprockets', '2.12.4'

#
# == Database
#
gem 'mysql2'
gem 'pg'
gem 'sqlite3'
gem 'ancestry'
gem 'database_cleaner'

#
# == Authentication
#
gem 'devise'
gem 'devise-i18n-views'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'

#
# == Administration
#
gem 'activeadmin', '~> 1.0.0.pre2'
gem 'activeadmin_addons'
gem 'acts_as_list'
gem 'activeadmin-sortable', github: 'mvdstam/activeadmin-sortable'
gem 'active_skin'

#
# == Decorator
#
gem 'draper'

#
# == Html
#
gem 'slim-rails' # slim file
gem 'kaminari', '~> 0.16.1' # Pagination
gem 'gretel', github: 'LoveMondays/gretel', branch: 'fix-semantic-breadcrumb-current-item' # Breadcrumb
gem 'rails_autolink'
gem 'truncate_html', github: 'AlexGunslinger/truncate_html'
gem 'outdatedbrowser_rails', github: 'anthony-robin/outdatedbrowser_rails'
gem 'vex_rails', github: 'anthony-robin/vex_rails'
gem 'jquery-minicolors-rails'
gem 'js_cookie_rails'
gem 'fotoramajs'

#
# == Calendar
#
gem 'fullcalendar-rails'
gem 'momentjs-rails'
gem 'timecop'

#
# == Media upload
#
gem 'paperclip', '~> 4.3'
gem 'retina_rails', '~> 2.0.0'
gem 'paperclip-av-transcoder'
gem 'delayed_paperclip'

#
# == Forms and WYSIWYG
#
gem 'simple_form'
gem 'client_side_validations', github: 'DavyJonesLocker/client_side_validations'
gem 'client_side_validations-simple_form', github: 'DavyJonesLocker/client_side_validations-simple_form'
gem 'rails_autosize_jquery', github: 'lr-agenceweb/rails_autosize_jquery'
gem 'wysiwyg-rails' # Froala editor
gem 'valid_url'
gem 'actionmailer-with-request'

#
# == Translation
#
gem 'route_translator'
gem 'globalize', '~> 5.0.0'
gem 'activeadmin-globalize', github: 'anthony-robin/activeadmin-globalize', branch: 'master'
gem 'rails-i18n', github: 'svenfuchs/rails-i18n', branch: 'rails-4-x'
gem 'i18n-js', '>= 3.0.0.rc12'

#
# == Map
#
gem 'mapbox-rails', github: 'anthony-robin/mapbox-rails'
gem 'gmaps-autocomplete-rails'

#
# == SEO
#
gem 'friendly_id', '~> 5.1'
gem 'sitemap_generator'
gem 'meta-tags'

#
# == Security
#
gem 'figaro'
gem 'cancancan', '~> 1.10'

#
# == Analytics
#
gem 'analytical'

#
# == Background Tasks
#
gem 'whenever', require: false # Cron tasks
gem 'daemons'
gem 'delayed_job_active_record'

#
# == Email
#
gem 'dkim' # authenticate emails
gem 'premailer-rails'
gem 'nokogiri'

#
# == Assets
#
gem 'sassc-rails'
gem 'autoprefixer-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-ui-rails'
gem 'jquery-datetimepicker-rails'
gem 'turbolinks'
gem 'nprogress-rails'
gem 'foundation-rails', '~> 5.5.3.2'
gem 'font-awesome-rails'
gem 'jbuilder', '~> 2.0'
gem 'gon'
gem 'gravatar_image_tag'
gem 'magnific-popup-rails', '~> 1.1.0'
gem 'chartkick'
gem 'faker'

#
# == Video
#
gem 'mediaelement_rails' # HTML5 video player
gem 'video_info'

#
# == Logs
#
gem 'lograge' # cleaner logs

group :development do
  gem 'better_errors'
  gem 'rb-fsevent', require: false
  gem 'irbtools-more', require: 'binding.repl'

  gem 'rubocop', require: false
  gem 'railroady' # graph of models
  gem 'shut_up_assets'
  gem 'annotate'

  # == Server
  gem 'unicorn-rails'

  # == Debug Rails request in Chrome DevTools
  gem 'meta_request'

  gem 'bullet' # display N+1 db queries
  gem 'shog' # colorize logs
  gem 'brakeman', require: false # check for security vulnerabilities

  # == Deploy
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
  gem 'spring', '~> 1.6.0'
end

group :test do
  gem 'minitest'
  gem 'minitest-reporters', require: false
  gem 'codeclimate-test-reporter', require: nil
  gem 'simplecov', require: false
  gem 'simplecov-json', require: false
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0'
end
