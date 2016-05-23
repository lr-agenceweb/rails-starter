# frozen_string_literal: true

#
# == MailingUsers Controller
#
class MailingUsersController < ApplicationController
  include ModuleSettingable
  include Mailingable

  before_action :not_found, unless: proc { @mailing_module.enabled? }
  before_action :set_mailing_user, only: [:unsubscribe]
  layout 'error'

  def unsubscribe
    raise ActionController::RoutingError, 'Not Found' if !params[:token] || @mailing_user.try(:token) != params[:token]
    @mailing_user.destroy
    @asocial = true
    render 'mailing_users/success_unsubscribe'
  end

  private

  def set_mailing_user
    @mailing_user = MailingUser.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    raise ActionController::RoutingError, 'Not Found'
  end
end
