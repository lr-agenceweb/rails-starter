# frozen_string_literal: true
require 'test_helper'

#
# == MenuDecorator test
#
class MenuDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # == Admin link
  #
  test 'should return correct title for show page' do
    menu_decorated = MenuDecorator.new(@menu_home)
    assert_equal I18n.t('menu.title_aa_show', menu_item: @menu_home.title), menu_decorated.title_aa_show
  end

  private

  def initialize_test
    @menu_home = menus(:home)
  end
end
