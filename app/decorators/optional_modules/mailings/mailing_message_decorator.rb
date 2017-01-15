# frozen_string_literal: true

#
# MailingMessageDecorator
# =========================
class MailingMessageDecorator < MailerDecorator
  include Draper::LazyHelpers
  delegate_all
end
