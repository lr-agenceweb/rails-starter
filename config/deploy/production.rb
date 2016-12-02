# frozen_string_literal: true
set :stage, :production
set :deploy_to, "#{Figaro.env.capistrano_deploy_to}/#{fetch(:stage)}/#{fetch(:application)}"

# Whenever cronjobs
set :whenever_environment, -> { fetch(:stage) }
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

set :host_name, -> { Figaro.env.application_host }
set :domain_name, -> { Figaro.env.application_domain_name }

# Puma config
set :nginx_server_name, fetch(:domain_name)

# server-based syntax
# ======================
server Figaro.env.capistrano_server_ip,
       user: fetch(:deploy_user).to_s,
       roles: %w(web app db),
       ssh_options: { forward_agent: true }
