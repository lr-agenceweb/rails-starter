require 'test_helper'

#
# == MapDecorator test
#
class MapDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  test 'should return correct value for marker_color' do
    map_setting_decorated = MapSettingDecorator.new(@map_setting)
    assert_equal "<div style=\"background-color: #{@map_setting.marker_color}; width: 35px; height: 20px;\"></div>", map_setting_decorated.marker_color_d
  end

  private

  def initialize_test
    @map_setting = map_settings(:one)
  end
end
