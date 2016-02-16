#
# == Newsletter Mailer
#
class NewsletterMailer < ApplicationMailer
  add_template_helper(HtmlHelper)
  layout 'newsletter'

  before_action :set_newsletter_settings

  # Email send after a user subscribed to the newsletter
  def welcome_user(newsletter_user)
    @newsletter_user = newsletter_user
    @newsletter_user.name = @newsletter_user.extract_name_from_email
    I18n.with_locale(@newsletter_user.lang) do
      welcome_newsletter = NewsletterSetting.first
      @title = welcome_newsletter.title_subscriber
      @content = welcome_newsletter.content_subscriber
      @is_welcome_user = true
      @hide_preview_link = false

      mail(
        from: Setting.first.try(:email),
        to: @newsletter_user.email,
        subject: @title
      ) do |format|
        format.html
        format.text
      end
    end
  end

  # Email Newsletter
  def send_newsletter(newsletter_user, newsletter)
    @newsletter_user = newsletter_user
    I18n.with_locale(@newsletter_user.lang) do
      @newsletter = Newsletter.find(newsletter.id)
      @title = @newsletter.title
      @content = @newsletter.content
      @hide_preview_link = false

      mail(
        from: Setting.first.try(:email),
        to: @newsletter_user.email,
        subject: @title
      ) do |format|
        format.html
        format.text
      end
    end
  end

  private

  def set_newsletter_settings
    @is_welcome_user = false
  end
end
