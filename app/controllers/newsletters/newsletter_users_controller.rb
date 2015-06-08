#
# == NewsletterUsersController
#
class NewsletterUsersController < ApplicationController
  before_action :set_newsletter_user, only: [:unsubscribe]
  after_action :send_welcome_newsletter, only: [:create]

  def create
    @newsletter_user = NewsletterUser.new(newsletter_user_params)
    respond_to do |format|
      if @newsletter_user.save
        format.html { redirect_to :back }
        format.js { render :show, status: :created }
      else
        format.html { redirect_to :back }
        format.js { render 'errors', status: :unprocessable_entity }
      end
    end
  end

  def unsubscribe
    if @newsletter_user.token == params[:token]
      @newsletter_user.destroy
      flash[:success] = I18n.t('newsletter.unsubscribe.success')
    else
      flash[:error] = I18n.t('newsletter.unsubscribe.fail')
    end

    # TODO: redirect to fr or en depending of the language
    redirect_to :root
  end

  private

  def newsletter_user_params
    params.require(:newsletter_user).permit(:email, :lang)
  end

  def set_newsletter_user
    @newsletter_user = NewsletterUser.find(params[:newsletter_user_id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = I18n.t('newsletter.unsubscribe.invalid')
      redirect_to :root
  end

  def send_welcome_newsletter
    # Sends email to user when user is created.
    SendEmailJob.set(wait: 10.seconds).perform_later(@newsletter_user)
  end
end
