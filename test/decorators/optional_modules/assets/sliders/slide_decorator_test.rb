# frozen_string_literal: true
require 'test_helper'

#
# == SlideDecorator test
#
class SlideDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # == Slide
  #
  test 'should return page title for slide image' do
    assert_equal 'Accueil', @slide_decorated.slider_page_name
  end

  test 'should return title for slide image' do
    assert_equal 'Titre slide 1', @slide_decorated.title
  end

  test 'should return description for slide image' do
    assert_equal 'Description slide 1', @slide_decorated.description_d
  end

  test 'should return correct value for caption?' do
    assert @slide_decorated.caption?
    assert_not @slide_two_decorated.caption?
  end

  #
  # == ActiveAdmin
  #
  test 'should return correct AA show page title' do
    assert_equal 'Slide liée au slider de la page Accueil', @slide_decorated.title_aa_show
  end

  test 'should return correct AA edit page title' do
    assert_equal 'Modifier Slide liée au slider de la page Accueil', @slide_decorated.title_aa_edit
  end

  private

  def initialize_test
    @slide = slides(:slide_one)
    @slide_two = slides(:slide_two)
    @slide_decorated = SlideDecorator.new(@slide)
    @slide_two_decorated = SlideDecorator.new(@slide_two)
  end
end
