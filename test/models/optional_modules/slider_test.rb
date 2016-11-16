# frozen_string_literal: true
require 'test_helper'

#
# Slider Model test
# ===================
class SliderTest < ActiveSupport::TestCase
  setup :initialize_test

  #
  # Shoulda
  # =========
  should belong_to(:page)
  should have_one(:slide)
  should have_many(:slides)

  should accept_nested_attributes_for(:slide)
  should accept_nested_attributes_for(:slides)

  should validate_presence_of(:page)
  should validate_presence_of(:time_to_show)
  should validate_presence_of(:animate)

  should validate_inclusion_of(:animate)
    .in_array(Slider.allowed_animations)

  #
  # Validation rules
  # ==================
  test 'should return list of allowed map markers' do
    allowed_animations = Slider.allowed_animations
    assert_includes allowed_animations, 'crossfade'
    assert_includes allowed_animations, 'slide'
    assert_includes allowed_animations, 'dissolve'
    assert_not_includes allowed_animations, 'popup'
  end

  test 'should not be valid if all good' do
    slider = Slider.new sliders_attrs
    assert slider.valid?
    assert_empty slider.errors.keys
  end

  test 'should not be valid if all empty' do
    slider = Slider.new {}
    assert_not slider.valid?
    assert_equal [:page, :animate], slider.errors.keys
  end

  test 'should not be valid if time_to_show is not empty' do
    attrs = sliders_attrs
    attrs[:time_to_show] = ''

    slider = Slider.new attrs
    assert_not slider.valid?
    assert_equal [:time_to_show], slider.errors.keys
  end

  test 'should not be valid if page is not present' do
    attrs = sliders_attrs
    attrs[:page] = nil

    slider = Slider.new attrs
    assert_not slider.valid?
    assert_equal [:page], slider.errors.keys
  end

  test 'should not be valid if animations is not allowed' do
    attrs = sliders_attrs
    attrs[:animate] = 'popup'

    slider = Slider.new attrs
    assert_not slider.valid?
    assert_equal [:animate], slider.errors.keys
  end

  #
  # Count
  # =======
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

  def sliders_attrs
    {
      time_to_show: 3000,
      page: pages(:blog),
      animate: 'crossfade'
    }
  end
end
