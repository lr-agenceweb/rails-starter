# frozen_string_literal: true
require 'test_helper'

#
# AdultSetting test
# ===================
class AdultSettingTest < ActiveSupport::TestCase
  setup :initialize_test

  #
  # Shoulda
  # =========
  should_not validate_presence_of(:redirect_link)

  #
  # Validation rules
  # ==================
  test 'should not create more than one setting' do
    adult_setting = AdultSetting.new
    assert_not adult_setting.valid?
    assert_equal [:max_row], adult_setting.errors.keys
    assert_equal [I18n.t('errors.messages.max_row')], adult_setting.errors[:max_row]
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
