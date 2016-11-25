# frozen_string_literal: true
require 'test_helper'

#
# SocialConnectSetting test
# ===========================
class SocialConnectSettingTest < ActiveSupport::TestCase
  #
  # Shoulda
  # =========
  should have_many(:social_providers)
  should accept_nested_attributes_for(:social_providers)

  #
  # Validation rules
  # ==================
  test 'should not create more than one setting' do
    social_setting = SocialConnectSetting.new
    assert_not social_setting.valid?
    assert_equal [:max_row], social_setting.errors.keys
    assert_equal [I18n.t('errors.messages.max_row')], social_setting.errors[:max_row]
  end
end
