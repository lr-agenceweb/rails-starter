#
# == NewslettersController
#
class NewslettersController < InheritedResources::Base
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
          redirect_to :root
        end
      end
    else
      redirect_to :root
    end
  end

  # See welcome email in browser
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
