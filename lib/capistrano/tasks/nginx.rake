# frozen_string_literal: true
namespace :nginx do
  %w(start stop restart reload status).each do |command|
    desc "#{command.capitalize} nginx service"
    task command do
      on roles(:app) do
        sudo :service, :nginx, command
      end
    end
  end
end
