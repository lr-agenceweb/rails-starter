require 'test_helper'

#
# == Setting model test
#
class SettingTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should return title and subtitle if subtitle is not blank' do
    assert_equal @setting.title_and_subtitle, 'Site title, Site subtitle'
  end

  test 'should return only title if subtitle is blank' do
    assert_equal @setting_without_subtitle.title_and_subtitle, 'Site title'
  end

  private

  def initialize_test
    @setting = settings(:one)
    @setting_without_subtitle = settings(:two)
  end
end
