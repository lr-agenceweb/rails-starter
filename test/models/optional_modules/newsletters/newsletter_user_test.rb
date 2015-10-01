require 'test_helper'

#
# == NewsletterUser model test
#
class NewsletterUserTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should have testers' do
    NewsletterUser.create(email: @email, lang: @lang, role: 'tester')
    assert NewsletterUser.testers?
  end

  test 'should not have testers' do
    NewsletterUser.create(email: @email, lang: @lang, role: 'subscriber')
    assert_not NewsletterUser.testers?
  end

  test 'should count testers' do
    assert_equal 0, NewsletterUser.testers.count
  end

  test 'should count subscriber' do
    assert_equal 3, NewsletterUser.subscribers.count
  end

  test 'should extract name from email' do
    assert_equal 'foo', @newsletter_user.extract_name_from_email
  end

  private

  def initialize_test
    @email = 'foo@bar.cc'
    @lang = 'fr'
    @newsletter_user = newsletter_users(:newsletter_user_test)
  end
end
