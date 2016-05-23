# frozen_string_literal: true

# Automatisation of database export
namespace :backup do
  desc 'Upload backup config files.'
  task :upload_config do
    on roles(:web) do
      execute "mkdir -p #{fetch(:backup_path)}/models"
      erb = File.read 'lib/capistrano/templates/backup_conf.erb'
      erb_dest = "#{fetch(:backup_path)}/models/#{fetch(:backup_name)}.rb"
      upload! StringIO.new(ERB.new(erb).result(binding)), erb_dest
    end
  end
end
