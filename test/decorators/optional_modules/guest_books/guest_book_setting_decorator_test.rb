require 'test_helper'

#
# == GuestBookSettingDecorator test
#
class GuestBookSettingDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # == Status tag
  #
  test 'should return correct status_tag if should validate' do
    assert_match "<span class=\"status_tag oui green\">Oui</span>", @guest_book_setting_decorated.should_validate
  end

  test 'should return correct status_tag if should not validate' do
    @guest_book_setting.update_attribute(:should_validate, false)
    assert_match "<span class=\"status_tag non red\">Non</span>", @guest_book_setting_decorated.should_validate
  end

  private

  def initialize_test
    @guest_book_setting = guest_book_settings(:one)
    @guest_book_setting_decorated = GuestBookSettingDecorator.new(@guest_book_setting)
  end
end
