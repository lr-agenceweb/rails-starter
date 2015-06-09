#
# == WelcomeNewsletter Job
#
class WelcomeNewsletterJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    @newsletter_user = user
    NewsletterMailer.welcome_user(@newsletter_user).deliver
  end
end
