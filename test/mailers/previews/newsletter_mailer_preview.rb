# Preview all emails at http://localhost:3000/rails/mailers/send_newsletter_preview
class NewsletterMailerPreview < ActionMailer::Preview
  def welcome_user_preview
    @is_welcome_user = true
    @newsletter_user = NewsletterUser.find(1)
    I18n.with_locale(@newsletter_user.lang) do
      NewsletterMailer.welcome_user(@newsletter_user)
    end
  end

  # def newsletter_preview
  #   @newsletter_user = NewsletterUser.english.first
  #   I18n.with_locale(@newsletter_user.lang) do
  #     NewsletterMailer.send_newsletter(@newsletter_user, Newsletter.find(2))
  #   end
  # end
end
