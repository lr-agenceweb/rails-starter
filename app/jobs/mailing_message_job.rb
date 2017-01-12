# frozen_string_literal: true

#
# MailingMessage Job
# ====================
class MailingMessageJob < ApplicationJob
  def perform(user, message)
    I18n.with_locale(user.lang) do
      opts = {
        mailing_user: user,
        mailing_message: message
      }

      MailingMessageMailer.send_email(opts).deliver_now
    end
  end
end
