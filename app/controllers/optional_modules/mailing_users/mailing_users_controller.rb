#
# == MailingUsers Controller
#
class MailingUsersController < ApplicationController
  before_action :not_found, only: [:unsubscribe], unless: proc { @mailing_module.enabled? }
  before_action :set_mailing_user, only: [:unsubscribe]
  layout 'error'

  def unsubscribe
    fail ActionController::RoutingError, 'Not Found' if !params[:token] || @mailing_user.try(:token) != params[:token]
    @mailing_user.destroy
    render template: 'mailing_users/success_unsubscribe'
  end

  private

  def set_mailing_user
    @mailing_user = MailingUser.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    fail ActionController::RoutingError, 'Not Found'
  end
end
