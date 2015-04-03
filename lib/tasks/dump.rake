# encoding: utf-8
require 'fileutils'

namespace :db do
  desc 'Backup project database. Options: DIR=backups RAILS_ENV=production MAX=7'
  task backup: [:environment] do
    # config base dir
    datestamp = Time.now.strftime('%Y%m%d%H%M')
    base_path = Rails.root
    backup_folder = File.join(base_path + 'db', ENV['DIR'] || 'backups')
    FileUtils.mkdir_p(backup_folder) unless File.exist?(backup_folder)

    # backup database
    backup_file = File.join(backup_folder, "#{Figaro.env.db_name}_#{Rails.env}_#{datestamp}.sql")
    `test -f #{backup_file}* && rm #{backup_file}*`
    `mysqldump -u #{Figaro.env.db_username} -p#{Figaro.env.db_password} -i -c -q #{Figaro.env.db_name} > #{backup_file}`
    fail 'Unable to make DB backup!' if $CHILD_STATUS.to_i > 0
    `gzip -9 #{backup_file}`

    # delete dulipute backups
    all_backups = Dir.new(backup_folder).entries.sort[2..-1].reverse
    puts "Created backup: #{backup_file}.gz successfully!"
    max_backups = (ENV['MAX'].to_i if ENV['MAX'].to_i > 0) || 30
    unwanted_backups = all_backups[max_backups..-1] || []
    unwanted_backups.each do |unwanted_backup|
      FileUtils.rm_rf(File.join(backup_folder, unwanted_backup))
    end
    puts "Deleted #{unwanted_backups.length} backups, #{all_backups.length - unwanted_backups.length} backups available"
    # print the absolute dir path for remote operate db
    puts "#{backup_file}.gz"
  end

  desc 'usage - bundle exec rake db:restore RAILS_ENV=production BACKUP_FILE=db/db.bak/backup_file.sql.gz'
  task restore: [:environment] do
    # config base dir
    backup_file = ENV['BACKUP_FILE']
    fail "No Exist File - #{backup_file}" unless File.exist?(backup_file)

    # restore database
    `gunzip < #{backup_file} | mysql -u #{Figaro.env.db_username} -p#{Figaro.env.db_password} -i -c -q #{Figaro.env.db_name}`
    fail "Unable to restore DB from #{backup_file}!" if $CHILD_STATUS.to_i > 0
    puts "Restore DB from #{backup_file} successfully!"
  end
end

# USAGE
# =====
# bundle exec rake db:backup  RAILS_ENV=production MAX=15 DIR=db/db.bak
# bundle exec rake db:restore RAILS_ENV=production BACKUP_FILE=db/db.bak/backup_file.sql.gz
