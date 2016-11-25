# frozen_string_literal: true
require 'test_helper'

#
# == BackgroundDecorator test
#
class BackgroundDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # == Background
  #
  test 'should return page title for background image' do
    assert_equal 'Accueil', @background_decorated.page_name
  end

  #
  # == ActiveAdmin
  #
  test 'should return correct AA show page title' do
    assert_equal 'Arrière-plan lié à la page "Accueil"', @background_decorated.title_aa_show
  end

  test 'should return correct AA edit page title' do
    assert_equal 'Modifier Arrière-plan page "Accueil"', @background_decorated.title_aa_edit
  end

  private

  def initialize_test
    @background = backgrounds(:home)
    @background_decorated = BackgroundDecorator.new(@background)
  end
end
