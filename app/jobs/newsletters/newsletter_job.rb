# frozen_string_literal: true

#
# Newsletter Job
# =================
class NewsletterJob < ApplicationJob
  def perform(user, newsletter)
    I18n.with_locale(user.lang) do
      opts = {
        newsletter_user: user,
        newsletter: newsletter
      }

      NewsletterMailer.send_newsletter(opts).deliver_now
    end
  end
end
