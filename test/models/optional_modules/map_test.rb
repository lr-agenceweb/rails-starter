require 'test_helper'

#
# == Map model test
#
class MapTest < ActiveSupport::TestCase
  test 'should return list of allowed map markers' do
    allowed_map_markers = Map.allowed_markers
    assert_includes allowed_map_markers, 'camera'
    assert_includes allowed_map_markers, 'building'
    assert_includes allowed_map_markers, 'park'
    assert_includes allowed_map_markers, 'car'
    assert_includes allowed_map_markers, 'bus'
    assert_includes allowed_map_markers, 'college'
    assert_includes allowed_map_markers, 'gift'
  end
end
