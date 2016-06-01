# frozen_string_literal: true

#
# == MailingMessages Controller
#
class MailingMessagesController < ApplicationController
  include ModuleSettingable
  include Mailingable

  before_action :not_found, unless: proc { @mailing_module.enabled? }
  layout 'mailing'

  def preview_in_browser
    raise ActionController::RoutingError, 'Not Found' unless all_conditions_respected?
    @title = @mailing_message.title
    @content = @mailing_message.content
    @hide_preview_link = true
    I18n.with_locale(params[:locale]) do
      render 'mailing_message_mailer/send_email'
    end
  end

  private

  def all_conditions_respected?
    params[:mailing_user_token] &&
      params[:token] &&
      @mailing_user.token == params[:mailing_user_token] &&
      @mailing_message.token == params[:token] &&
      @mailing_message.already_sent?
  end
end
