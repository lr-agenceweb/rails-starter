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
  end
end
