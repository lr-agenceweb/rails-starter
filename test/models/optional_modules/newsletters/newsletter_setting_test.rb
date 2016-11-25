# frozen_string_literal: true
require 'test_helper'

#
# NewsletterSetting test
# ========================
class NewsletterSettingTest < ActiveSupport::TestCase
  #
  # Shoulda
  # =========
  should have_many(:newsletter_user_roles)
  should accept_nested_attributes_for(:newsletter_user_roles)

  #
  # Validation rules
  # ==================
  test 'should not create more than one setting' do
    newsletter_setting = NewsletterSetting.new
    assert_not newsletter_setting.valid?
    assert_equal [:max_row], newsletter_setting.errors.keys
    assert_equal [I18n.t('errors.messages.max_row')], newsletter_setting.errors[:max_row]
  end
end
