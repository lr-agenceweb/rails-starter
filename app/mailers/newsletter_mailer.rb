# frozen_string_literal: true

#
# Newsletter Mailer
# ===================
class NewsletterMailer < ApplicationMailer
  layout 'mailers/newsletter'

  # Callbacks
  before_action :set_vars

  # Administrator => Customer
  # Email send after a user subscribed to the newsletter
  def welcome_user(opts)
    extract_vars(opts)
    @is_welcome_user = true

    I18n.with_locale(@newsletter_user.lang) do
      @newsletter = Newsletter.new(
        title: @newsletter_setting.title_subscriber,
        content: @newsletter_setting.content_subscriber
      )
    end

    process_email
  end

  # Administrator => Customer
  def send_newsletter(opts)
    extract_vars(opts)
    process_email
  end

  private

  def set_vars
    @is_welcome_user = false
    @hide_preview_link = false
  end

  def extract_vars(opts)
    @newsletter ||= opts[:newsletter]
    @newsletter_user ||= opts[:newsletter_user]
    @newsletter_setting ||= opts[:newsletter_setting]
  end

  def process_email
    subject = I18n.with_locale(@newsletter_user.lang) do
      default_i18n_subject(site: @setting.title, title: @newsletter.title)
    end

    mail from: @from_admin,
         to: @newsletter_user.email,
         subject: subject do |format|
      format.html
      format.text { render layout: 'mailers/default' }
    end
  end
end
