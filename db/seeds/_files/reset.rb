# frozen_string_literal: true

#
# == Resest content and setup id to 1
#
puts 'Reset table ID to 1'
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

dir = "#{Rails.root}/public/system/#{Rails.env}"
if Dir.exist?(dir)
  puts "Delete public/system/#{Rails.env} folder"
  FileUtils.rm_rf(dir)
end
