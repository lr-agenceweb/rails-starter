require 'test_helper'

#
# == Category model test
#
class CategoryTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should return title for category' do
    assert_equal 'Accueil', Category.title_by_category(@category.name)
  end

  test 'should return only allowed modules' do
    assert_equal 8, Category.with_allowed_module.count
  end

  test 'should have a slider linked for home category' do
    assert @category.slider?
  end

  test 'should not have any slider linked for search category' do
    assert_not @search_category.slider?
  end

  private

  def initialize_test
    @category = categories(:home)
    @search_category = categories(:search)
  end
end
