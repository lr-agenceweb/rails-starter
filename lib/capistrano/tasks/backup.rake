# frozen_string_literal: true

# Automatisation of database export
namespace :backup do
  namespace :upload do
    desc 'Upload backup config file.'
    task :config do # cap <env> backup:upload:config
      on roles(:web) do
        execute "mkdir -p #{fetch(:backup_path)}/models"
        erb = File.read 'lib/capistrano/templates/backup/config.erb'
        erb_dest = "#{fetch(:backup_path)}/config.rb"
        upload! StringIO.new(ERB.new(erb).result(binding)), erb_dest
      end
    end

    desc 'Upload backup model file.'
    task :model do # cap <env> backup:upload:model
      on roles(:web) do
        execute "mkdir -p #{fetch(:backup_path)}/models"
        erb = File.read 'lib/capistrano/templates/backup/model.erb'
        erb_dest = "#{fetch(:backup_path)}/models/#{fetch(:backup_name)}.rb"
        upload! StringIO.new(ERB.new(erb).result(binding)), erb_dest
      end
    end

    desc 'Upload backup config and model files.'
    task :all do # cap <env> backup:upload:all
      invoke 'backup:upload:config'
      invoke 'backup:upload:model'
    end
  end
end
