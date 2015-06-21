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

  private

  def initialize_test
    @email = 'aaa@bbb.cc'
    @lang = 'fr'
  end
end
