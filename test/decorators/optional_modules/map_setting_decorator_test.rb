# frozen_string_literal: true
require 'test_helper'

#
# == MapSettingDecorator test
#
class MapSettingDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  test 'should return correct value for marker_color' do
    assert_equal "<div style=\"background-color: #{@map_setting.marker_color}; width: 35px; height: 20px;\"></div>", @map_setting_decorated.marker_color_preview
  end

  private

  def initialize_test
    @map_setting = map_settings(:one)
    @map_setting_decorated = MapSettingDecorator.new(@map_setting)
  end
end
