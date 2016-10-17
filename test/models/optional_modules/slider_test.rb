# frozen_string_literal: true
require 'test_helper'

#
# == Slider model test
#
class SliderTest < ActiveSupport::TestCase
  setup :initialize_test

  #
  # == Validation rules
  #
  test 'should return list of allowed map markers' do
    allowed_animations = Slider.allowed_animations
    assert_includes allowed_animations, 'crossfade'
    assert_includes allowed_animations, 'slide'
    assert_includes allowed_animations, 'dissolve'
    assert_not_includes allowed_animations, 'popup'
  end

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
