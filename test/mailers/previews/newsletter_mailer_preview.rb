# frozen_string_literal: true

#
# == Newsletter Mailer preview
# Preview all emails at http://localhost:3000/rails/mailers/newsletter_preview
#
class NewsletterMailerPreview < ActionMailer::Preview
  def welcome_user_preview
    @is_welcome_user = true
    @newsletter_user = NewsletterUser.find(2)
    NewsletterMailer.welcome_user(@newsletter_user)
  end

  def newsletter_preview
    @newsletter_user = NewsletterUser.english.first
    NewsletterMailer.send_newsletter(@newsletter_user, Newsletter.find(1))
  end
end
