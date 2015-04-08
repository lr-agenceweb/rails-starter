require 'test_helper'

#
# == LanguageHelper Test
#
class LanguageHelperTest < ActionView::TestCase
  include LanguageHelper

  test 'should return true if current locale is right' do
    params[:locale] = :fr
    assert current_locale?(:fr)
  end

  test 'should return false if current locale is wrong' do
    params[:locale] = :fr
    assert_not current_locale?(:en)
  end
end
