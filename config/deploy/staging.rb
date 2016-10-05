# frozen_string_literal: true
set :stage, :staging
set :deploy_to, "#{Figaro.env.capistrano_deploy_to}/#{fetch(:stage)}/#{fetch(:application)}"

# Whenever cronjobs
set :whenever_environment, -> { fetch(:stage) }
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

set :domain_name, -> { Figaro.env.application_domain_name_staging }
set :host_name, -> { Figaro.env.application_host_staging }

# server-based syntax
# ======================
server Figaro.env.capistrano_server_ip, user: fetch(:deploy_user).to_s, roles: %w( web app db )

# Callbacks
# =========
namespace :deploy do
  after 'deploy:publishing', :update_branch do
    run "cd #{current_release}; sed -i 's/BranchName/#{fetch(:branch)}/g' app/helpers/application_helper.rb"
  end
end
