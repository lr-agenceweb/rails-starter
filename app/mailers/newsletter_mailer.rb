#
# == Newsletter Mailer
#
class NewsletterMailer < ApplicationMailer
  add_template_helper(HtmlHelper)
  default from: Setting.first.try(:email)
  layout 'newsletter'

  # Email send after a user subscribed to the newsletter
  def welcome_user(newsletter_user)
    @newsletter_user = newsletter_user
    @newsletter_user.name = @newsletter_user.extract_name_from_email
    @title = t('newsletter.welcome')
    @is_welcome_user = true
    @see_in_browser = true

    mail(to: @newsletter_user.email, subject: @title) do |format|
      format.html
      format.text
    end
  end

  # Email Newsletter
  def send_newsletter(newsletter_user, newsletter)
    @newsletter_user = newsletter_user
    @newsletter = newsletter
    @title = @newsletter.title

    mail(to: @newsletter_user.email, subject: @newsletter.title) do |format|
      format.html
      format.text
    end
  end
end
