# frozen_string_literal: true
require 'yaml'
app_config = YAML.load_file("#{path}/config/application.yml")

set :output, error: "#{path}/log/error.log", standard: "#{path}/log/cron.log"

every 1.day, at: '4:00 am' do
  rake '-s sitemap:refresh'
  rake 'db:backup MAX=10'
end

case @environment
when 'production'
  every 1.day, at: '4:00 am' do
    command "backup perform -t #{app_config['application_name'].tr('-', '_')}"
  end
end
