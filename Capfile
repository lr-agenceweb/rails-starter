# frozen_string_literal: true

# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Include tasks from other gems included in your Gemfile
require 'capistrano/rails'
require 'capistrano/rvm'
require 'capistrano/rails/collection'
require 'capistrano/puma'
require 'capistrano/puma/nginx'
require 'capistrano/sitemap_generator'
require 'capistrano/delayed_job'
require 'whenever/capistrano'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
