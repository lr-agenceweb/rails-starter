#
# == WelcomeNewsletter Job
#
class WelcomeNewsletterJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    NewsletterMailer.welcome_user(user).deliver
  end
end
