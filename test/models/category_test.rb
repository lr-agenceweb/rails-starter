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
    assert_equal %w( Home About Contact Search GuestBook ), Category.models_name_str
  end

  test 'should return list of categories name in symbol' do
    assert_equal [:Home, :About, :Contact, :Search, :GuestBook], Category.models_name
  end

  test 'should return only visible header element' do
    assert_equal 3, Category.visible_header.count
  end

  test 'should return only visible footer element' do
    assert_equal 1, Category.visible_footer.count
  end

  private

  def initialize_test
    @category = categories(:home)
  end
end
