require 'figaro'

# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'rails-starter'
set :repo_url, 'git@github.com:anthony-robin/rails-starter.git'

set :deploy_user, 'anthony'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/anthony/www/#{fetch(:application)}"

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/application.yml', 'public/sitemap.xml', 'config/dkim/dkim.private.key')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/sitemap')

# Default value for default_env is {}
set :default_env, rvm_bin_path: '~/.rvm/bin'

# Default value for keep_releases is 5
set :keep_releases, 5

# Backup
set :backup_path, "/home/#{fetch(:deploy_user)}/Backup"
set :backup_name, 'rails_starter'

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
