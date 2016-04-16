# frozen_string_literal: true
require 'test_helper'

#
# == SocialConnectSetting test
#
class SocialConnectSettingTest < ActiveSupport::TestCase
  #
  # == Validation
  #
  test 'should not create more than one setting' do
    social_setting = SocialConnectSetting.new
    assert_not social_setting.valid?
    assert_equal [:max_row], social_setting.errors.keys
    assert_equal [I18n.t('form.errors.max_row')], social_setting.errors[:max_row]
  end
end
