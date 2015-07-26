require 'test_helper'

#
# == Slider model test
#
class SliderTest < ActiveSupport::TestCase
  setup :initialize_test

  #
  # == Count
  #
  test 'should only fetch one slider online' do
    assert_equal 1, Slider.online.length
  end

  test 'should have only 2 pictures online' do
    assert_equal 2, @slider.slides_online.length
  end

  private

  def initialize_test
    @slider = sliders(:online)
  end
end
