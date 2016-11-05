# frozen_string_literal: true
namespace :nginx do
  namespace :upload do
    desc 'Upload the nginx vhost configuration file'
    task :vhost do
      on roles(:web) do
        erb = File.read 'lib/capistrano/templates/nginx_conf.erb'
        config_file = "/tmp/nginx_#{fetch(:application)}.#{fetch(:stage)}"
        upload! StringIO.new(ERB.new(erb).result(binding)), config_file
        sudo :mv, config_file, "/etc/nginx/conf.d/#{fetch(:application)}.#{fetch(:stage)}.conf"
        sudo :service, :nginx, :restart
      end
    end

    desc 'Upload the nginx vhost SSL configuration file'
    task :vhost_ssl do
      on roles(:web) do
        erb = File.read 'lib/capistrano/templates/nginx_ssl_conf.erb'
        config_file = "/tmp/nginx_#{fetch(:application)}.#{fetch(:stage)}"
        upload! StringIO.new(ERB.new(erb).result(binding)), config_file
        sudo :mv, config_file, "/etc/nginx/conf.d/#{fetch(:application)}.#{fetch(:stage)}.conf"
        sudo :service, :nginx, :restart
      end
    end
  end

  namespace :vhost do
    desc 'Symlink to /var/www'
    task :symlink do
      on roles(:web) do
        sudo :mkdir, '-p', "/var/www/#{fetch(:stage)}"
        sudo :ln, '-fs', current_path, "/var/www/#{fetch(:stage)}/#{fetch(:application)}"
      end
    end

    desc 'Disable vhost configuration'
    task :disable do
      on roles(:web) do
        sudo :mv, "/etc/nginx/conf.d/#{fetch(:application)}.#{fetch(:stage)}.conf", "/etc/nginx/conf.d/#{fetch(:application)}.#{fetch(:stage)}.disabled"
        sudo :service, :nginx, :restart
      end
    end

    desc 'Enable vhost configuration'
    task :enable do
      on roles(:web) do
        sudo :mv, "/etc/nginx/conf.d/#{fetch(:application)}.#{fetch(:stage)}.disabled", "/etc/nginx/conf.d/#{fetch(:application)}.#{fetch(:stage)}.conf"
        sudo :service, :nginx, :restart
      end
    end

    desc 'Remove vhost configuration'
    task :remove do
      on roles(:web) do
        sudo :rm, '-f', "/etc/nginx/conf.d/#{fetch(:application)}.#{fetch(:stage)}.conf"
        sudo :rm, '-f', "/etc/nginx/conf.d/#{fetch(:application)}.#{fetch(:stage)}.disabled"
        sudo :service, :nginx, :restart
      end
    end
  end
end
