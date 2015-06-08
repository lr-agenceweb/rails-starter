#
# == NewslettersController
#
class NewslettersController < ApplicationController
  before_action :set_newsletter_user, only: [:show, :welcome_user]
  before_action :set_variables, only: [:show, :welcome_user]

  def show
    if @newsletter_user.token == params[:token]
      I18n.with_locale(@newsletter_user.lang) do
        @newsletter = Newsletter.find(params[:id])
        @title = @newsletter.title
      end
      render layout: 'newsletter'
    else
      redirect_to :root
    end
  end

  def welcome_user
    if @newsletter_user.token == params[:token]
      I18n.with_locale(@newsletter_user.lang) do
        @title = I18n.t('newsletter.welcome')
      end
      render layout: 'newsletter'
    else
      redirect_to :root
    end
  end

  private

  def set_variables
    @host = Figaro.env.application_host
    @from_controller = true
  end

  def set_newsletter_user
    @newsletter_user = NewsletterUser.find(params[:newsletter_user_id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = I18n.t('newsletter.unsubscribe.invalid')
      redirect_to :root
  end
end
