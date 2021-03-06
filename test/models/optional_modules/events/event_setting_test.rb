# frozen_string_literal: true
require 'test_helper'

#
# EventSetting Model test
# =========================
class EventSettingTest < ActiveSupport::TestCase
  #
  # Shoulda
  # =========
  should belong_to(:event_order)

  #
  # Validation rules
  # ==================
  test 'should not create more than one setting' do
    event_setting = EventSetting.new
    assert_not event_setting.valid?
    assert_equal [:max_row], event_setting.errors.keys
    assert_equal [I18n.t('errors.messages.max_row')], event_setting.errors[:max_row]
  end
end
