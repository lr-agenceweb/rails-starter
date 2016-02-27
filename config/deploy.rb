require File.expand_path('../environment',  __FILE__)
require 'figaro'

# config valid only for current version of Capistrano
lock '3.4.0'

set :application, Figaro.env.application_name
set :repo_url, Figaro.env.capistrano_repo_url

set :deploy_user, Figaro.env.capistrano_deploy_user

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

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
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/sitemap', 'db/seeds')

# Default value for default_env is {}
set :default_env, rvm_bin_path: '~/.rvm/bin'

# Default value for keep_releases is 5
set :keep_releases, 5

# Backup database config files
set :backup_path, "/home/#{fetch(:deploy_user)}/Backup"
set :backup_name, Figaro.env.application_name.underscore

namespace :deploy do
  desc 'Symlink shared directories and files'
  task :upload_yml do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      execute "mkdir -p #{shared_path}/public"
      upload! StringIO.new(File.read('config/application.yml')), "#{shared_path}/config/application.yml"
      upload! StringIO.new(File.read('config/database.yml')), "#{shared_path}/config/database.yml"
      upload! StringIO.new(File.read('config/secrets.yml')), "#{shared_path}/config/secrets.yml"
      upload! StringIO.new(File.read('config/analytical.example.yml')), "#{shared_path}/config/analytical.yml"
      upload! StringIO.new(File.read('public/sitemap.xml')), "#{shared_path}/public/sitemap.xml"
      sudo :chmod, '644', "#{shared_path}/public/sitemap.xml"
    end
  end

  desc 'Upload DKIM private key'
  task :upload_dkim do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config/dkim"
      upload! StringIO.new(File.read('config/dkim/dkim.private.key')), "#{shared_path}/config/dkim/dkim.private.key"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
