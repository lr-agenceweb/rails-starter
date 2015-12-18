#
# == MailingableConcern
#
module Mailingable
  extend ActiveSupport::Concern

  included do
    before_action :set_mailing_user,
                  only: [:preview_in_browser]
    before_action :set_mailing_message,
                  only: [
                    :preview,
                    :preview_in_browser,
                    :send_mailing_message
                  ]
    before_action :set_mailing_setting,
                  only: [
                    :unsubscribe,
                    :preview,
                    :preview_in_browser,
                    :send_mailing_message
                  ]

    private

    def set_mailing_message
      @mailing_message = MailingMessage.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      raise ActionController::RoutingError, 'Not Found'
    end

    def set_mailing_setting
      @mailing_setting = MailingSetting.first
    rescue ActiveRecord::RecordNotFound
      raise ActionController::RoutingError, 'Not Found'
    end

    def set_mailing_user
      @mailing_user = MailingUser.find(params[:mailing_user_id])
    rescue ActiveRecord::RecordNotFound
      raise ActionController::RoutingError, 'Not Found'
    end
  end
end
