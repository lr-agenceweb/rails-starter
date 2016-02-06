#
# == NewsletterUsersController
#
class NewsletterUsersController < ApplicationController
  include ModuleSettingable
  include NewsletterUserable

  after_action :send_welcome_newsletter, only: [:create], if: proc { @newsletter_setting.send_welcome_email? && @newsletter_user.valid? }

  def create
    @newsletter_user = NewsletterUser.new(newsletter_user_params)
    @newsletter_user.newsletter_user_role_id = NewsletterUserRole.find_by(kind: 'subscriber').id
    respond_to do |format|
      if @newsletter_user.save
        format.html { redirect_to :back, flash: { success: I18n.t('newsletter.subscribe_success', email: @newsletter_user.email) } }
        format.js { render :show, status: :created }
      else
        format.html { redirect_to :back, flash: { alert: I18n.t('newsletter.subscribe_error') } }
        format.js { render 'errors', status: :unprocessable_entity }
      end
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
    params.require(:newsletter_user).permit(:email, :lang, :nickname)
  end

  # Sends email to user when subscription.
  def send_welcome_newsletter
    I18n.with_locale(@newsletter_user.lang) do
      WelcomeNewsletterJob.set(wait: 10.seconds).perform_later(@newsletter_user)
    end
  end
end
