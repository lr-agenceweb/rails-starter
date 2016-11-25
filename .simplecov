# frozen_string_literal: true

SimpleCov.start 'rails' do
  add_filter 'lib/mailer_previews'
  add_filter 'lib/assets'
  add_filter 'lib/rails'

  add_group 'Decorators', 'app/decorators'
  add_group 'ActiveAdmin', 'app/admin'
end
