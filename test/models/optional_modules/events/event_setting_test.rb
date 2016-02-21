require 'test_helper'

#
# == EventSetting test
#
class EventSettingTest < ActiveSupport::TestCase
  #
  # == Validation
  #
  test 'should not create more than one setting' do
    event_setting = EventSetting.new
    assert_not event_setting.valid?
    assert_equal [:max_row], event_setting.errors.keys
  end
end
