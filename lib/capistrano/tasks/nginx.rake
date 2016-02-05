namespace :nginx do
  desc 'Upload the nginx vhost configuration file'
  task :upload_vhost do
    on roles(:web) do
      erb = File.read 'lib/capistrano/templates/nginx_conf.erb'
      config_file = "/tmp/nginx_#{Figaro.env.application_domain_name}"
      upload! StringIO.new(ERB.new(erb).result(binding)), config_file
      sudo :mv, config_file, "/etc/nginx/sites-available/#{Figaro.env.application_domain_name}"
    end
  end

  desc 'Symlink the vhost to sites-enabled'
  task :symlink_vhost do
    on roles(:web) do
      sudo :ln, '-fs', "/etc/nginx/sites-available/#{Figaro.env.application_domain_name}", "/etc/nginx/sites-enabled/#{Figaro.env.application_domain_name}"
      sudo :service, :nginx, :restart
    end
  end

  desc 'Remove all vhost configuration'
  task :remove_vhost do
    on roles(:web) do
      sudo :rm, '-f', "/etc/nginx/sites-available/#{Figaro.env.application_domain_name}"
        invoke 'nginx:remove_symlink_vhost'
    end
  end

  desc 'Remove symlink for vhost'
  task :remove_symlink_vhost do
    on roles(:web) do
      sudo :rm, '-f', "/etc/nginx/sites-enabled/#{Figaro.env.application_domain_name}"
      sudo :service, :nginx, :restart
    end
  end
end