# frozen_string_literal: true
require 'test_helper'

#
# MailingMessageUser Model test
# ===============================
class MailingMessageUserTest < ActiveSupport::TestCase
  #
  # Shoulda
  # =========
  should belong_to(:mailing_user)
  should belong_to(:mailing_message)
end
