#
# == NewslettersController
#
class NewslettersController < ApplicationController
  include NewsletterAid
  before_action :set_newsletter_user, only: [:see_in_browser, :welcome_user]
  before_action :set_variables, only: [:see_in_browser, :welcome_user]

  # See Newsletter in browser
  def see_in_browser
    if @newsletter_user.token == params[:token]
      I18n.with_locale(@newsletter_user.lang) do
        @newsletter = Newsletter.find(params[:id])
        if @newsletter.already_sent?
          @title = @newsletter.title
          render layout: 'newsletter'
        else
          redirect_to root_path(locale: @newsletter_user.lang)
        end
      end
    else
      redirect_to root_path(locale: @newsletter_user.lang)
    end
  end

  # See welcome email in browser
  def welcome_user
    if @newsletter_user.token == params[:token]
      I18n.with_locale(@newsletter_user.lang) do
        welcome_newsletter = StringBox.find_by(key: 'welcome_newsletter')
        @title = welcome_newsletter.title
        @content = welcome_newsletter.content
        @newsletter_user.name = @newsletter_user.extract_name_from_email
      end
      render layout: 'newsletter'
    else
      redirect_to :root
    end
  end

  private

  def set_variables
    @from_controller = true
    @map = Map.joins(:location).select('locations.id, locations.address, locations.city, locations.postcode').first
  end

  def set_newsletter_user
    @newsletter_user = NewsletterUser.find(params[:newsletter_user_id])
  end
end
