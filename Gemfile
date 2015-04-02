source 'https://rubygems.org'

#
# == Ruby
#
ruby '2.2.0'

#
# == Rails
#
gem 'rails', '4.2.0'

#
# == Database
#
gem 'sqlite3'
gem 'mysql2'

#
# == Administration
#
gem 'devise'
gem 'activeadmin', github: 'activeadmin'

#
# == Html
#
gem 'slim-rails' # slim file
gem 'kaminari', '~> 0.16.1' # Pagination
gem 'gretel' # Breadcrumb
gem 'rails_autolink'
gem 'truncate_html'
gem 'chosen-rails'

#
# == Media upload
#
gem 'paperclip', github: 'thoughtbot/paperclip'
gem 'retina_rails', '~> 2.0.0'

#
# == Forms and WYSIWYG
#
gem 'simple_form'
gem 'client_side_validations', github: 'DavyJonesLocker/client_side_validations'
gem 'client_side_validations-simple_form', github: 'DavyJonesLocker/client_side_validations-simple_form'
gem 'autosize-rails'
gem 'mail_form' # contact form
gem "wysiwyg-rails" # Froala editor

#
# == Translation
#
gem 'route_translator'
gem 'globalize', '~> 5.0.0'
gem 'activeadmin-globalize', github: 'anthony-robin/activeadmin-globalize', branch: 'master'

#
# == Map
#
gem 'mapbox-rails', github: 'seshook/mapbox-rails'
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

#
# == Analytics
#
gem 'analytical'

#
# == Background Tasks
#
gem 'whenever', require: false # Cron tasks

#
# == Email
#
gem 'dkim' # authenticate emails
gem 'premailer-rails'
gem 'nokogiri'

#
# == Assets
#
gem 'sass-rails', '~> 5.0'
gem 'compass-rails', github: 'Compass/compass-rails', branch: 'master'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-ui-rails'
gem 'jquery-scrollto-rails'
gem 'jquery-datetimepicker-rails'
gem 'turbolinks'
gem 'nprogress-rails'
gem 'foundation-rails'
gem 'font-awesome-rails'
gem 'jbuilder', '~> 2.0'
gem 'gon'

group :development do
  gem 'better_errors'
  gem 'rb-fsevent', require: false
  gem 'irbtools-more', require: 'binding.repl'

  gem 'rails_best_practices'
  gem 'rubocop', require: false
  gem 'rails_layout'
  gem 'railroady' # graph of models
  gem 'quiet_assets', '~> 1.0.2'
  gem 'seed_dump'
  gem 'annotate', '~> 2.6.5'

  # == Server
  gem 'unicorn-rails'

  # == Debug Rails request in Chrome DevTools
  gem 'meta_request'
end

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
end

group :test do
  gem 'minitest'
  gem 'minitest-reporters'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0'
end