namespace :backup do
  desc 'Upload backup config files.'

  task :upload_config do
    on roles(:app) do
      execute "mkdir -p #{fetch(:backup_path)}/models"
      upload! StringIO.new(File.read("config/backup/#{fetch(:backup_name)}.rb")), "#{fetch(:backup_path)}/models/#{fetch(:backup_name)}.rb"
    end
  end
end
