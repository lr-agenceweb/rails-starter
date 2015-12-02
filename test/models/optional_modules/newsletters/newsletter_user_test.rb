require 'test_helper'

#
# == NewsletterUser model test
#
class NewsletterUserTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should have testers' do
    assert NewsletterUser.testers.map(&:email).include?('foo@bar.com'), "\"foo@bar.com\" should be tester"
    assert_not NewsletterUser.testers.map(&:email).include?('newsletteruser@test.fr'), "\"newsletteruser@test.fr\" should not be tester"
  end

  test 'should have subscriber' do
    assert NewsletterUser.subscribers.map(&:email).include?('newsletteruser@test.fr'), "\"newsletteruser@test.fr\" should be subscriber"
    assert_not NewsletterUser.subscribers.map(&:email).include?('foo@bar.com'), "\"foo@bar.com\" should not be subscriber"
  end

  test 'should extract name from email' do
    assert_equal 'foo', @newsletter_user.extract_name_from_email
  end

  private

  def initialize_test
    @email = 'foo@bar.cc'
    @lang = 'fr'
    @newsletter_user = newsletter_users(:newsletter_user_test)
    @newsletter_user_role_tester = newsletter_user_roles(:tester)
    @newsletter_user_role_subscriber = newsletter_user_roles(:subscriber)
  end
end
