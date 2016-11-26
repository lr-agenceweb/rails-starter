# frozen_string_literal: true
require 'test_helper'

#
# MapSetting Model test
# =======================
class MapSettingTest < ActiveSupport::TestCase
  #
  # Shoulda
  # =========
  should have_one(:location)
  should accept_nested_attributes_for(:location)

  should_not validate_presence_of(:marker_icon)

  should validate_inclusion_of(:marker_icon)
    .in_array(MapSetting.allowed_markers)

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
  # Validation rules
  # ==================
  test 'should not create more than one setting' do
    map_setting = MapSetting.new
    assert_not map_setting.valid?
    assert_equal [:max_row], map_setting.errors.keys
    assert_equal [I18n.t('errors.messages.max_row')], map_setting.errors[:max_row]
  end
end
