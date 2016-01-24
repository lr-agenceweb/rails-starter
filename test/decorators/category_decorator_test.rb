require 'test_helper'

#
# == CategoryDecorator test
#
class CategoryDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  test 'should return correct menu title' do
    assert_equal 'Accueil', @category_decorated.title_d
  end

  test 'should return correct value for background_deco' do
    assert_equal 'Pas de Background associé', @category_decorated.background_deco
    assert_equal 'Pas de Background associé', @category_about_decorated.background_deco
  end

  #
  # ActiveAdmin
  #
  test 'should return correct AA show page title' do
    assert_equal "Page \"Accueil\"", @category_decorated.title_aa_show
    assert_equal "Page \"A Propos\"", @category_about_decorated.title_aa_show
  end

  test 'should return correct AA edit page title' do
    assert_equal "Modifier page \"Accueil\"", @category_decorated.title_aa_edit
    assert_equal "Modifier page \"A propos\"", @category_about_decorated.title_aa_edit
  end

  private

  def initialize_test
    @category = categories(:home)
    @category_about = categories(:about)
    @category_decorated = CategoryDecorator.new(@category)
    @category_about_decorated = CategoryDecorator.new(@category_about)
  end
end
