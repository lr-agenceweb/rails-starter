namespace :upload do
  desc 'Symlink shared directories and files'
  task :yml do
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
  task :dkim do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config/dkim"
      upload! StringIO.new(File.read('config/dkim/dkim.private.key')), "#{shared_path}/config/dkim/dkim.private.key"
    end
  end

  desc 'Upload default missing pictures'
  task :missing do
    on roles(:app) do
      remote_public_folder = "#{shared_path}/public"
      execute "mkdir -p #{shared_path}/public"
      system 'cd public; zip -r default.zip default'
      upload! 'public/default.zip', "#{remote_public_folder}/default.zip"
      execute "unzip -o #{remote_public_folder}/default.zip -d #{remote_public_folder}/"
      execute "rm #{remote_public_folder}/default.zip"
      system 'cd public; rm default.zip'
    end
  end
end
