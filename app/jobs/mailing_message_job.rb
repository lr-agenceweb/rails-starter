# frozen_string_literal: true

#
# MailingMessage Job
# ======================
class MailingMessageJob < ApplicationJob
  def perform(user, message)
    MailingMessageMailer.send_email(user, message).deliver_now
  end
end
