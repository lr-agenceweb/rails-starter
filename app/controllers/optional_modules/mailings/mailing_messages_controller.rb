# frozen_string_literal: true

#
# MailingMessages Controller
# ============================
class MailingMessagesController < ApplicationController
  include ModuleSettingable
  include Mailingable

  layout 'mailers/mailing'

  # Callbacks
  before_action :not_found,
                unless: proc {
                  @mailing_module.enabled? && allowed_to_preview?
                }

  def preview_in_browser
    I18n.with_locale(params[:locale]) do
      @hide_preview_link = true
      render 'mailing_message_mailer/send_email'
    end
  end

  private

  def allowed_to_preview?
    params[:mailing_user_token] &&
      params[:token] &&
      @mailing_user.token == params[:mailing_user_token] &&
      @mailing_message.token == params[:token] &&
      @mailing_message.already_sent?
  end
end
