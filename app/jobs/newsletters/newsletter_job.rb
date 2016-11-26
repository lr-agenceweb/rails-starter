# frozen_string_literal: true

#
# Newsletter Job
# ==================
class NewsletterJob < ApplicationJob
  def perform(user, newsletter)
    NewsletterMailer.send_newsletter(user, newsletter).deliver_now
  end
end
