require 'test_helper'

#
# == MailingMessage Model
#
class MailingMessageTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should be linked to correct emailing user(s)' do
    assert_includes @mailing_message.mailing_users.map(&:fullname), @mailing_user.fullname
    assert_not_includes @mailing_message.mailing_users.map(&:fullname), @mailing_user_two.fullname
  end

  private

  def initialize_test
    @mailing_message = mailing_messages(:one)
    @mailing_user = mailing_users(:one)
    @mailing_user_two = mailing_users(:two)
  end
end
