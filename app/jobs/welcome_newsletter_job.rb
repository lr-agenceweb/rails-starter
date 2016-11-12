# frozen_string_literal: true

#
# WelcomeNewsletter Job
# ==========================
class WelcomeNewsletterJob < ApplicationJob
  def perform(user)
    NewsletterMailer.welcome_user(user).deliver_now
  end
end
