# frozen_string_literal: true

#
# WelcomeNewsletter Job
# ==========================
class WelcomeNewsletterJob < ApplicationJob
  def perform(user, setting)
    I18n.with_locale(user.lang) do
      opts = {
        newsletter_user: user,
        newsletter_setting: setting.decorate
      }

      NewsletterMailer.welcome_user(opts).deliver_now
    end
  end
end
