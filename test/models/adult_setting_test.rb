require 'test_helper'

#
# == AdultSetting test
#
class AdultSettingTest < ActiveSupport::TestCase
  setup :initialize_test

  #
  # == Validation
  #
  test 'should not create more than one setting' do
    adult_setting = AdultSetting.new
    assert_not adult_setting.valid?
    assert_equal [:max_row], adult_setting.errors.keys
  end

  test 'should not be valid if link is not a correct url' do
    @adult_setting.update_attribute(:redirect_link, 'fakeurl')
    assert_not @adult_setting.valid?
    assert_equal [:redirect_link], @adult_setting.errors.keys
  end

  private

  def initialize_test
    @adult_setting = adult_settings(:one)
  end
end
