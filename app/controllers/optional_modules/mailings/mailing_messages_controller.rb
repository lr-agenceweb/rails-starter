#
# == MailingMessages Controller
#
class MailingMessagesController < ApplicationController
  before_action :not_found, unless: proc { @mailing_module.enabled? }
  before_action :set_mailing_user, only: [:preview_in_browser]
  before_action :set_mailing_message, only: [:preview_in_browser]
  layout 'mailing'

  def preview_in_browser
    if all_conditions_respected?
      @title = @mailing_message.title
      @content = @mailing_message.content
      @hide_preview_link = true
      I18n.with_locale(params[:locale]) do
        render 'mailing_message_mailer/send_email'
      end
    else
      fail ActionController::RoutingError, 'Not Found'
    end
  end

  private

  def set_mailing_user
    @mailing_user = MailingUser.find(params[:mailing_user_id])
  rescue ActiveRecord::RecordNotFound
    fail ActionController::RoutingError, 'Not Found'
  end

  def set_mailing_message
    @mailing_message = MailingMessage.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    fail ActionController::RoutingError, 'Not Found'
  end

  def all_conditions_respected?
    params[:mailing_user_token] &&
    params[:token] &&
    @mailing_user.token == params[:mailing_user_token] &&
    @mailing_message.token == params[:token] &&
  end
end
