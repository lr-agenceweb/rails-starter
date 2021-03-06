# frozen_string_literal: true
namespace :logrotate do
  desc 'Upload logrotate configuration for application'
  task :upload do # cap <env> logrotate:upload
    on roles(:web) do
      erb = File.read 'lib/capistrano/templates/logrotate_conf.erb'
      logrotate_file_tmp = "/tmp/logrotate_#{fetch(:application)}.#{fetch(:stage)}.conf"
      logrotate_file_dest = "/etc/logrotate.d/#{fetch(:application)}.#{fetch(:stage)}.conf"
      upload! StringIO.new(ERB.new(erb).result(binding)), logrotate_file_tmp
      sudo :mv, logrotate_file_tmp, logrotate_file_dest
      sudo :chown, :root, logrotate_file_dest
      sudo :chmod, '644', logrotate_file_dest
    end
  end
end
