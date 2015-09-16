require 'test_helper'

#
# == Menu model test
#
class MenuTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should return only online menu elements' do
    menu_items = Menu.online
    expected = ['Home', 'Search', 'GuestBook', 'Blog', 'Events', 'About', 'Contact']
    not_expected = ['Test offline']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return only parents elements' do
    menu_items = Menu.only_parents
    expected = ['Home', 'Search', 'GuestBook', 'Blog', 'Events', 'Contact', 'Test offline']
    not_expected = ['About']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return only online parents elements' do
    menu_items = Menu.online.only_parents
    expected = ['Home', 'Search', 'GuestBook', 'Blog', 'Events', 'Contact']
    not_expected = ['About', 'Test offline']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return only online menu items with category linked' do
    menu_items = Menu.online.with_page
    expected = ['Home', 'Search', 'GuestBook', 'Blog', 'Events', 'Contact', 'About']
    not_expected = ['Test online', 'Test offline']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return only online visible header elements' do
    menu_items = Menu.online.visible_header
    expected = ['Home', 'GuestBook', 'Blog', 'Events', 'Contact', 'About']
    not_expected = ['Search', 'Test online', 'Test offline']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return only online visible footer elements' do
    menu_items = Menu.online.visible_footer
    expected = ['About', 'Test online']
    not_expected = ['Home', 'GuestBook', 'Blog', 'Events', 'Contact', 'Search', 'Test offline']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return only online elements with allowed modules' do
    @guest_book_module.update_attributes!(enabled: false)
    menu_items = Menu.online.with_allowed_modules
    expected = ['Home', 'About', 'Blog', 'Events', 'Contact', 'Search']
    not_expected = ['Test offline', 'GuestBook', 'Test online']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return only online, visible_header, only_parents, with_page, with allowed modules' do
    @event_module.update_attributes!(enabled: false)
    menu_items = Menu.online.only_parents.with_page.visible_header.with_allowed_modules
    expected = ['Home', 'Blog', 'Contact', 'GuestBook']
    not_expected = ['Test offline', 'Event', 'About', 'Test online', 'Search']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  #
  # == ActiveAdmin (select collection)
  #
  test 'should return all menu except current (when nil) and submenu' do
    menu_items = Menu.except_current_and_submenus
    expected = ['Home', 'Blog', 'Events', 'Contact', 'Search', 'Test offline', 'GuestBook', 'Test online']
    not_expected = ['About']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return all menu except current (not nil) and submenu' do
    menu_items = Menu.except_current_and_submenus(@menu_home)
    expected = ['Blog', 'Events', 'Contact', 'Search', 'Test offline', 'GuestBook', 'Test online']
    not_expected = ['Home', 'About']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return correct menu items to link page to category (current nil)' do
    menu_items = Menu.self_or_available
    expected = ['Test online', 'Test offline']
    not_expected = ['Blog', 'Events', 'Contact', 'Search', 'GuestBook', 'About']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return correct menu items to link page to category (current not nil)' do
    menu_items = Menu.self_or_available(@menu_home.category)
    expected = ['Home', 'Test online', 'Test offline']
    not_expected = ['Blog', 'Events', 'Contact', 'Search', 'GuestBook', 'About']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  private

  def initialize_test
    @menu_home = menus(:home)
    @guest_book_module = optional_modules(:guest_book)
    @event_module = optional_modules(:event)
  end

  def expected_in_menu(expected, menu_items)
    expected.each do |item|
      assert menu_items.map { |a| a.title }.include?(item), "\"#{item}\" should be included in menu"
    end
  end

  def not_expected_in_menu(not_expected, menu_items)
    not_expected.each do |item|
      assert_not menu_items.map { |a| a.title }.include?(item), "\"#{item}\" should not be included in menu"
    end
  end
end
