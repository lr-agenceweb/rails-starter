# frozen_string_literal: true

#
# Newsletter Mailer preview
# http://localhost:3000/rails/mailers/newsletter_preview
# ============================
class NewsletterMailerPreview < ActionMailer::Preview
  def welcome_user_preview
    set_vars
    @is_welcome_user = true
    NewsletterMailer.welcome_user(opts)
  end

  def newsletter_preview
    set_vars
    @newsletter_user = NewsletterUser.english.first
    NewsletterMailer.send_newsletter(opts)
  end

  private

  def set_vars
    @newsletter = Newsletter.first.decorate
    @newsletter_user = NewsletterUser.find(2)
    @newsletter_setting = NewsletterSetting.first.decorate
  end

  def opts
    {
      newsletter: @newsletter,
      newsletter_user: @newsletter_user,
      newsletter_setting: @newsletter_setting
    }
  end
end
