# frozen_string_literal: true

#
# == Module Assets
#
module Assets
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
        model_name = table_name.classify.constantize

        # Options
        attachment_path = "#{table_name}/:id/:style-:filename"
        options[:path] ||= ":rails_root/public/system/#{Rails.env}/#{attachment_path}"
        options[:url] ||= "/system/#{Rails.env}/#{attachment_path}"

        # Default options
        options[:retina]      = { quality: 70 }
        options[:default_url] = '/default/:style-missing.png'

        # Paperclip attachment
        has_attached_file name, options

        # Paperclip validation
        validates_attachment name,
                             content_type: {
                               content_type: model_name::ATTACHMENT_TYPES
                             },
                             size: {
                               less_than: model_name::ATTACHMENT_MAX_SIZE.megabyte
                             }
      end
    end
  end
end
