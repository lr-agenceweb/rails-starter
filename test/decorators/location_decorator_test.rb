require 'test_helper'

#
# == LocationDecorator test
#
class LocationDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  test 'should return correct address inline' do
    location = LocationDecorator.new(@location_one)
    assert_equal "<span>1 Main Street, 06001 - Auckland</span>", location.full_address_inline
  end

  test 'should return true as boolean for latlon?' do
    location = LocationDecorator.new(@location_one)
    assert location.latlon?
  end

  test 'should return false as boolean for latlon?' do
    location = LocationDecorator.new(@location_two)
    assert_not location.latlon?
  end

  private

  def initialize_test
    @location_one = locations(:one)
    @location_two = locations(:two)
  end
end
