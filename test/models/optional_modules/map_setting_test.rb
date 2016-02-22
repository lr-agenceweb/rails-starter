require 'test_helper'

#
# == MapSetting model test
#
class MapSettingTest < ActiveSupport::TestCase
  test 'should return list of allowed map markers' do
    allowed_map_markers = MapSetting.allowed_markers
    assert_includes allowed_map_markers, 'camera'
    assert_includes allowed_map_markers, 'building'
    assert_includes allowed_map_markers, 'park'
    assert_includes allowed_map_markers, 'car'
    assert_includes allowed_map_markers, 'bus'
    assert_includes allowed_map_markers, 'college'
    assert_includes allowed_map_markers, 'gift'
  end

  #
  # == Validation
  #
  test 'should not create more than one setting' do
    map_setting = MapSetting.new
    assert_not map_setting.valid?
    assert_equal [:max_row], map_setting.errors.keys
    assert_equal [I18n.t('form.errors.max_row')], map_setting.errors[:max_row]
  end
end
