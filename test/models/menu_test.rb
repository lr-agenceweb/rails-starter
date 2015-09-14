require 'test_helper'

#
# == Menu model test
#
class MenuTest < ActiveSupport::TestCase
  # TODO: Fix these tests
  test 'should return only visible header element' do
    assert_equal 6, Menu.visible_header.length
  end

  test 'should return only visible footer element' do
    assert_equal 0, Menu.visible_footer.length
  end

  # test 'should return only visible header element with allowed modules' do
  #   assert_equal 5, Category.with_allowed_module.visible_header.count
  # end
end
