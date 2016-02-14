require 'test_helper'

#
# == NewsletterUserDecorator test
#
class NewsletterUserDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  test 'should return correct value for tester? boolean' do
    assert_not @newsletter_user_decorated.tester?
    assert @newsletter_user_test_decorated.tester?
  end

  test 'should return correct value for subscriber? boolean' do
    assert @newsletter_user_decorated.subscriber?
    assert_not @newsletter_user_test_decorated.subscriber?
  end

  #
  # == Status tag
  #
  test 'should return correct status_tag if tester' do
    assert_match '<span class="status_tag testeur orange">Testeur</span>', @newsletter_user_test_decorated.role_status
  end

  test 'should return correct status_tag if subscriber' do
    assert_match '<span class="status_tag abonné green">Abonné</span>', @newsletter_user_decorated.role_status
  end

  private

  def initialize_test
    @newsletter_user = newsletter_users(:newsletter_user_fr)
    @newsletter_user_test = newsletter_users(:newsletter_user_test)

    @newsletter_user_decorated = NewsletterUserDecorator.new(@newsletter_user)
    @newsletter_user_test_decorated = NewsletterUserDecorator.new(@newsletter_user_test)
  end
end
