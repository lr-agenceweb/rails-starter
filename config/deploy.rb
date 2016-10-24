# frozen_string_literal: true
require File.expand_path('../environment', __FILE__)
require 'figaro'

# config valid only for current version of Capistrano
lock '3.6.1'

set :application, Figaro.env.application_name
set :repo_url, Figaro.env.capistrano_repo_url
set :deploy_user, Figaro.env.capistrano_deploy_user
set :rvm_ruby_version, Figaro.env.capistrano_rvm_ruby_version || 'default'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
current_branch = `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, ENV['branch'] || current_branch

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/application.yml', 'config/dkim/dkim.private.key', 'public/sitemap.xml', 'config/analytical.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/sitemap')

# Default value for default_env is {}
set :default_env, rvm_bin_path: '~/.rvm/bin'

# Default value for keep_releases is 5
set :keep_releases, 5

# Backup database config files
set :backup_path, "/home/#{fetch(:deploy_user)}/Backup"
set :backup_name, Figaro.env.application_name.underscore

# Callbacks
# =========
namespace :deploy do
  # Restart passenger after finishing deployment
  after :finishing, :restart_passenger do
    on roles(:web) do
      within release_path do
        execute :touch, 'tmp/restart.txt'
      end
    end
  end
end
