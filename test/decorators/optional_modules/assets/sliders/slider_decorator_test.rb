# frozen_string_literal: true
require 'test_helper'

#
# == SliderDecorator test
#
class SliderDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # == Slide
  #
  test 'should return page title for slider' do
    assert_equal 'Accueil', @slider_decorated.page
  end

  #
  # == ActiveAdmin
  #
  test 'should return correct AA show page title' do
    assert_equal 'Slider page Accueil', @slider_decorated.title_aa_show
  end

  test 'should return correct value for time_to_show' do
    assert_equal '5 secondes', @slider_decorated.time_to_show
  end

  private

  def initialize_test
    @slider = sliders(:online)
    @slider_decorated = SliderDecorator.new(@slider)
  end
end
