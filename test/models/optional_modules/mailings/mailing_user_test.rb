require 'test_helper'

#
# == MailingUserTest Model
#
class MailingUserTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should be linked to correct emailing message(s)' do
    assert_includes @mailing_user.mailing_messages.map(&:title), @mailing_message.title
    assert_not_includes @mailing_user.mailing_messages.map(&:title), @mailing_message_two.title
  end

  private

  def initialize_test
    @mailing_user = mailing_users(:one)
    @mailing_message = mailing_messages(:one)
    @mailing_message_two = mailing_messages(:two)
  end
end
