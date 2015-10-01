#
# == NewsletterUsersController
#
class NewsletterUsersController < ApplicationController
  include NewsletterAid
  before_action :set_newsletter_setting, only: [:create]
  after_action :send_welcome_newsletter, only: [:create], if: proc { @newsletter_setting.send_welcome_email && @success }

  def create
    if params[:newsletter_user][:nickname].blank?
      @success = false
      @newsletter_user = NewsletterUser.new(newsletter_user_params)
      respond_to do |format|
        if @newsletter_user.save
          @success = true
          format.html { redirect_to :back, flash: { success: I18n.t('newsletter.subscribe_success', email: @newsletter_user.email) } }
          format.js { render :show, status: :created }
        else
          format.html { redirect_to :back, flash: { alert: I18n.t('newsletter.subscribe_error') } }
          format.js { render 'errors', status: :unprocessable_entity }
        end
      end
    else
      render nothing: true
    end
  end

  def unsubscribe
    if @newsletter_user.token == params[:token]
      lang = @newsletter_user.lang
      @newsletter_user.destroy
      flash[:success] = I18n.t('newsletter.unsubscribe.success')
    else
      flash[:error] = I18n.t('newsletter.unsubscribe.fail')
    end

    redirect_to root_path(locale: lang)
  end

  private

  def newsletter_user_params
    params.require(:newsletter_user).permit(:email, :lang)
  end

  def set_newsletter_setting
    @newsletter_setting = NewsletterSetting.first
  end

  # Sends email to user when user is created.
  def send_welcome_newsletter
    I18n.with_locale(@newsletter_user.lang) do
      WelcomeNewsletterJob.set(wait: 10.seconds).perform_later(@newsletter_user)
    end
  end
end
