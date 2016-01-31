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
    assert_equal 'Title for slide one', @slide_decorated.title
  end

  test 'should return description for slide image' do
    assert_equal 'Description for slide one', @slide_decorated.description_deco
  end

  test 'should format caption for slide image' do
    assert_equal "<div class=\"caption\"><h3 class=\"caption-title\">Title for slide one</h3><div class=\"caption-content\">Description for slide one</div></div>", @slide_decorated.caption
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
    @slide_decorated = SlideDecorator.new(@slide)
  end
end
