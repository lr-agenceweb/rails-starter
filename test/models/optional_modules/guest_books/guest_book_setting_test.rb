# frozen_string_literal: true
require 'test_helper'

#
# GuestBookSetting Model test
# =============================
class GuestBookSettingTest < ActiveSupport::TestCase
  #
  # Validation rules
  # ==================
  test 'should not create more than one setting' do
    guest_book_setting = GuestBookSetting.new
    assert_not guest_book_setting.valid?
    assert_equal [:max_row], guest_book_setting.errors.keys
    assert_equal [I18n.t('errors.messages.max_row')], guest_book_setting.errors[:max_row]
  end
end
