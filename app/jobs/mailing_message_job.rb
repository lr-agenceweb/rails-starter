# frozen_string_literal: true
#
# == MailingMessage Job
#
class MailingMessageJob < ActiveJob::Base
  queue_as :default

  def perform(user, message)
    MailingMessageMailer.send_email(user, message).deliver_now
  end
end
