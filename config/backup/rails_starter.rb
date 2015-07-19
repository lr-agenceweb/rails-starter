# encoding: utf-8

##
# Backup Generated: rails_starter
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t rails_starter [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://backup.github.io/backup
#
app_config = YAML.load_file('/home/anthony/www/staging/rails-starter/shared/config/application.yml')

LR_Backup.new(:rails_starter, "Site #{app_config['application_host']}") do

  ##
  # MySQL [Database]
  #
  database MySQL, app_config['db_name'].to_sym do |db|
    db.name     = app_config['db_name']
    db.username = app_config['db_username']
    db.password = app_config['db_password']
    db.host     = app_config['db_host']
  end

  ##
  # Dropbox [Storage]
  #
  store_with Dropbox do |db|
    db.api_key     = app_config['dropbox']['api_key']
    db.api_secret  = app_config['dropbox']['api_secret']
    db.cache_path  = ".cache"
    db.access_type = :app_folder
    db.path        = '/'
    db.keep        = 15
  end

  ##
  # Slack [Notifier]
  #
  notify_by Slack do |slack|
    slack.on_success = true
    slack.on_warning = true
    slack.on_failure = true

    # The integration token
    slack.webhook_url = app_config['slack']['webhook_url']
    slack.channel     = app_config['slack']['channel']
    slack.username    = app_config['slack']['username']
    slack.icon_emoji  = ':ghost:'
  end
end