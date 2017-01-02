# frozen_string_literal: true

#
# Newsletter Mailer
# ===================
class NewsletterMailer < ApplicationMailer
  add_template_helper(HtmlHelper)
  layout 'mailers/newsletter'

  before_action :set_newsletter_settings

  # Email send after a user subscribed to the newsletter
  def welcome_user(newsletter_user)
    @newsletter_user = newsletter_user
    @newsletter_user.name = @newsletter_user.extract_name_from_email
    I18n.with_locale(@newsletter_user.lang) do
      wn = NewsletterSetting.first
      @content = wn.content_subscriber
      @is_welcome_user = true
      process_email(wn.title_subscriber)
    end
  end

  # Email Newsletter
  def send_newsletter(newsletter_user, newsletter)
    @newsletter_user = newsletter_user
    I18n.with_locale(@newsletter_user.lang) do
      @newsletter = Newsletter.find(newsletter.id)
      @content = @newsletter.content
      process_email(@newsletter.title)
    end
  end

  private

  def set_newsletter_settings
    @is_welcome_user = false
    @hide_preview_link = false
  end

  def process_email(title)
    mail from: @setting.email,
         to: @newsletter_user.email,
         subject: default_i18n_subject(title: title) do |format|
      format.html
      format.text { render layout: 'mailers/default' }
    end
  end
end
