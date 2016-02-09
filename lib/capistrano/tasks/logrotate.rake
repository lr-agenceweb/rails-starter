namespace :logrotate do
  desc 'Upload logrotate configuration for application'
  task :upload_config do
    on roles(:web) do
      erb = File.read 'lib/capistrano/templates/logrotate_conf.erb'
      logrotate_file_tmp = "/tmp/logrotate_#{Figaro.env.application_domain_name}.conf"
      logrotate_file_dest = "/etc/logrotate.d/#{Figaro.env.application_domain_name}.conf"
      upload! StringIO.new(ERB.new(erb).result(binding)), logrotate_file_tmp
      sudo :mv, logrotate_file_tmp, logrotate_file_dest
      sudo :chown, :root, logrotate_file_dest
      sudo :chmod, '644', logrotate_file_dest
    end
  end
end
