# frozen_string_literal: true
require 'test_helper'

#
# == StringBoxDecorator test
#
class StringBoxDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  test 'should return correct title' do
    string_box_decorated = StringBoxDecorator.new(@string_box)
    assert string_box_decorated.title?
    assert_equal 'Erreur 404', string_box_decorated.title_aa_show
  end

  test 'should return correct content' do
    string_box_decorated = StringBoxDecorator.new(@string_box)
    assert string_box_decorated.content?
    assert_equal "<p>Cette page n'existe pas ou n'existe plus.<br /> Nous vous prions de nous excuser pour la gêne occasionnée.</p>", string_box_decorated.content
  end

  test 'should return title by key if no one is set' do
    string_box_decorated = StringBoxDecorator.new(@string_box_without_title)
    assert_not string_box_decorated.title?
    assert_equal 'Error 422', string_box_decorated.title_aa_show
  end

  private

  def initialize_test
    @string_box = string_boxes(:error_404)
    @string_box_without_title = string_boxes(:error_422)
  end
end
