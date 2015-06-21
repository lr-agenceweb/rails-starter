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

  test 'should extract name from email' do
    assert_equal @newsletter_user.extract_name_from_email, 'foo'
  end

  private

  def initialize_test
    @email = 'foo@bar.cc'
    @lang = 'fr'
    @newsletter_user = newsletter_users(:newsletter_user_test)
  end
end
