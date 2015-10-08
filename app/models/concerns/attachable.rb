#
# == Attachable module
#
module Attachable
  extend ActiveSupport::Concern

  #
  # == ClassMethod
  #
  module ClassMethods
    def handle_attachment(name, options = {})
      model_name = table_name
      attachment_path = "#{model_name}/:id/:style-:filename"

      options[:path] ||= ":rails_root/public/system/#{Rails.env}/#{attachment_path}"
      options[:url] ||= "/system/#{Rails.env}/#{attachment_path}"

      # # conditionals options
      # if Rails.env.staging? || Rails.env.production?
      #   options[:storage] ||= :dropbox
      #   options[:dropbox_credentials] ||= File.join(Rails.root, 'config', 'dropbox.yml')
      #   options[:path] ||= attachment_path
      # else
      #   options[:path] ||= ":rails_root/public/system/#{Rails.env}/#{attachment_path}"
      #   options[:url] ||= "/system/#{Rails.env}/#{attachment_path}"
      # end

      # default options
      options[:retina]      = { quality: 70 }
      options[:default_url] = '/default/:style-missing.png'

      # paperclip
      has_attached_file name, options
    end
  end
end
