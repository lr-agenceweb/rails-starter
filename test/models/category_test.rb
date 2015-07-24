require 'test_helper'

#
# == Category model test
#
class CategoryTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should return title for category' do
    assert_equal 'Accueil', Category.title_by_category(@category.name)
  end

  test 'should return list of categories name in string' do
    assert_includes Category.models_name_str, 'Home'
    assert_includes Category.models_name_str, 'About'
    assert_includes Category.models_name_str, 'Contact'
    assert_includes Category.models_name_str, 'Search'
    assert_includes Category.models_name_str, 'GuestBook'
    assert_includes Category.models_name_str, 'Blog'
  end

  test 'should return list of categories name in symbol' do
    assert_includes Category.models_name, :Home
    assert_includes Category.models_name, :About
    assert_includes Category.models_name, :Contact
    assert_includes Category.models_name, :Search
    assert_includes Category.models_name, :GuestBook
    assert_includes Category.models_name, :Blog
  end

  test 'should return only visible header element' do
    assert_equal 5, Category.visible_header.count
  end

  test 'should return only visible header element with allowed modules' do
    assert_equal 5, Category.with_allowed_module.visible_header.count
  end

  test 'should return only allowed modules' do
    assert_equal 7, Category.with_allowed_module.count
  end

  test 'should return only visible footer element' do
    assert_equal 1, Category.visible_footer.count
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
