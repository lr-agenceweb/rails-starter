require 'test_helper'

#
# == Slider model test
#
class SliderTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should only fetch one slider online' do
    assert_equal 1, Slider.online
  end

  private

  def initialize_test
    @slider = sliders(:one)
  end
end
