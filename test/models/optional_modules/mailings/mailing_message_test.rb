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

  test 'should not be linked anymore if message destroyed' do
    skip 'Find a way to make this test pass'
  end

  private

  def initialize_test
    @mailing_message = mailing_messages(:one)
    @mailing_user = mailing_users(:one)
    @mailing_user_two = mailing_users(:two)
  end
end
