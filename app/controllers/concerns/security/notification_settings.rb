# frozen_string_literal: true

#
# == Security namespace
#
module Security
  #
  # == NotificationSettings
  #
  module NotificationSettings
    extend ActiveSupport::Concern

    included do
      before_action :set_notification_settings

      def set_notification_settings
        request.env['exception_notifier.exception_data'] = {
          'Application name': Figaro.env.application_name,
          'Site': ENV["application_host_#{Rails.env}"]
        }
      end
    end
  end
end
