#
# == Newsletterable Concern
#
module Newsletterable
  extend ActiveSupport::Concern

  included do
    before_action :set_newsletter, only: [
      :send_newsletter,
      :send_newsletter_test,
      :see_in_browser,
      :welcome_user
    ]
  end

  def set_newsletter
    @newsletter = Newsletter.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    raise ActionController::RoutingError, 'Not Found'
  end
end
