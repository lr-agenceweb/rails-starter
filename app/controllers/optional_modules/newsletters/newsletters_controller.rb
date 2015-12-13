#
# == NewslettersController
#
class NewslettersController < ApplicationController
  include NewsletterAid
  before_action :not_found, unless: proc { @newsletter_module.enabled? }
  before_action :set_variables, only: [:see_in_browser, :welcome_user]
  layout 'newsletter'

  # See Newsletter in browser
  def see_in_browser
    if @newsletter_user.token == params[:token]
      I18n.with_locale(@newsletter_user.lang) do
        @newsletter = Newsletter.find(params[:id])
        fail ActionController::RoutingError, 'Not Found' unless @newsletter.already_sent?
        @title = @newsletter.title
        @content = @newsletter.content
      end
    else
      fail ActionController::RoutingError, 'Not Found'
    end
  end

  # See welcome email in browser
  def welcome_user
    if @newsletter_user.token == params[:token]
      I18n.with_locale(@newsletter_user.lang) do
        welcome_newsletter = NewsletterSetting.first
        @title = welcome_newsletter.try(:title_subscriber)
        @content = welcome_newsletter.try(:content_subscriber)
        @newsletter_user.name = @newsletter_user.extract_name_from_email
      end
    else
      fail ActionController::RoutingError, 'Not Found'
    end
  end

  private

  def set_variables
    @hide_preview_link = true
    @map = Map.joins(:location).select('locations.id, locations.address, locations.city, locations.postcode').first
  end
end
