# frozen_string_literal: true
#
# == Newsletter Job
#
class NewsletterJob < ActiveJob::Base
  queue_as :default

  def perform(user, newsletter)
    NewsletterMailer.send_newsletter(user, newsletter).deliver_now
  end
end
