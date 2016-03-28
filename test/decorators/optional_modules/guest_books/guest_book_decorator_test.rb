# frozen_string_literal: true
require 'test_helper'

#
# == GuestBookDecorator test
#
class GuestBookDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # == Content
  #
  test 'should return correct content connected' do
    assert_equal 'Bravo pour le site', @guest_book_decorated.content
  end

  private

  def initialize_test
    @guest_book = guest_books(:fr_validate)
    @guest_book_decorated = GuestBookDecorator.new(@guest_book)
  end
end
