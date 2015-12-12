require 'test_helper'

#
# == Menu model test
#
class MenuTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should return only online menu elements' do
    menu_items = Menu.online
    expected = ['Accueil', 'Recherche', 'Livre d\'or', 'Blog', 'Evénements', 'A propos', 'Contact']
    not_expected = ['Test hors-ligne']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return only parents elements' do
    menu_items = Menu.only_parents
    expected = ['Accueil', 'Recherche', 'Livre d\'or', 'Blog', 'Evénements', 'Contact', 'Test hors-ligne']
    not_expected = ['A propos']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return only online parents elements' do
    menu_items = Menu.online.only_parents
    expected = ['Accueil', 'Recherche', 'Livre d\'or', 'Blog', 'Evénements', 'Contact']
    not_expected = ['A propos', 'Test hors-ligne']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return only online menu items with category linked' do
    menu_items = Menu.online.with_page
    expected = ['Accueil', 'Recherche', 'Livre d\'or', 'Blog', 'Evénements', 'Contact', 'A propos']
    not_expected = ['Test en-ligne', 'Test hors-ligne']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return only online visible header elements' do
    menu_items = Menu.online.visible_header
    expected = ['Accueil', 'Livre d\'or', 'Blog', 'Evénements', 'Contact', 'A propos']
    not_expected = ['Recherche', 'Test en-ligne', 'Test hors-ligne']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return only online visible footer elements' do
    menu_items = Menu.online.visible_footer
    expected = ['A propos', 'Test en-ligne']
    not_expected = ['Accueil', 'Livre d\'or', 'Blog', 'Evénements', 'Contact', 'Recherche', 'Test hors-ligne']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return only online elements with allowed modules' do
    @guest_book_module.update_attributes!(enabled: false)
    menu_items = Menu.online.with_allowed_modules
    expected = ['Accueil', 'A propos', 'Blog', 'Evénements', 'Contact', 'Recherche']
    not_expected = ['Test hors-ligne', 'Livre d\'or', 'Test en-ligne']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return only online, visible_header, only_parents, with_page, with allowed modules' do
    @event_module.update_attributes!(enabled: false)
    menu_items = Menu.online.only_parents.with_page.visible_header.with_allowed_modules
    expected = ['Accueil', 'Blog', 'Contact', 'Livre d\'or']
    not_expected = ['Test hors-ligne', 'Event', 'A propos', 'Test en-ligne', 'Recherche']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  #
  # == ActiveAdmin (select collection)
  #
  test 'should return all menu except current (when nil) and submenu' do
    menu_items = Menu.except_current_and_submenus
    expected = ['Accueil', 'Blog', 'Evénements', 'Contact', 'Recherche', 'Test hors-ligne', 'Livre d\'or', 'Test en-ligne']
    not_expected = ['A propos']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return all menu except current (not nil) and submenu' do
    menu_items = Menu.except_current_and_submenus(@menu_home)
    expected = ['Blog', 'Evénements', 'Contact', 'Recherche', 'Test hors-ligne', 'Livre d\'or', 'Test en-ligne']
    not_expected = ['Accueil', 'A propos']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return correct menu items to link page to category (current nil)' do
    menu_items = Menu.self_or_available
    expected = ['Test en-ligne', 'Test hors-ligne']
    not_expected = ['Blog', 'Evénements', 'Contact', 'Recherche', 'Livre d\'or', 'A propos']

    expected_in_menu(expected, menu_items)
    not_expected_in_menu(not_expected, menu_items)
  end

  test 'should return correct menu items to link page to category (current not nil)' do
    menu_items = Menu.self_or_available(@menu_home.category)
    expected = ['Accueil', 'Test en-ligne', 'Test hors-ligne']
    not_expected = ['Blog', 'Evénements', 'Contact', 'Recherche', 'Livre d\'or', 'A propos']

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
      assert menu_items.map(&:title).include?(item), "\"#{item}\" should be included in menu"
    end
  end

  def not_expected_in_menu(not_expected, menu_items)
    not_expected.each do |item|
      assert_not menu_items.map(&:title).include?(item), "\"#{item}\" should not be included in menu"
    end
  end
end
