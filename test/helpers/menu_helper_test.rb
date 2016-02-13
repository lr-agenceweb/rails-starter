require 'test_helper'

#
# == MenuHelper Test
#
class MenuHelperTest < ActionView::TestCase
  include MenuHelper

  setup :initialize_test

  test 'should return active class for home' do
    assert_equal set_active_class('homes', 'index'), 'active'
  end

  test 'should not return active class if action is show for home' do
    assert_nil set_active_class('homes', 'show')
  end

  test 'should return active class if action is false for home' do
    assert_equal set_active_class('homes'), 'active'
  end

  test 'should not return active class for contact' do
    assert_nil set_active_class('contacts', 'new')
  end

  test 'should not return active class if action is false for contact' do
    assert_nil set_active_class('contacts')
  end

  test 'should return correct even or odd class for menu' do
    items = Menu.online.only_parents.with_page.with_allowed_modules.visible_header
    assert_equal 'even', even_or_odd_menu_item(items)
  end

  private

  def initialize_test
    params[:controller] = 'homes'
    params[:action] = 'index'
  end
end
