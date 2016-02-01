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

  #
  # == Status tag
  #
  test 'should return correct status tag if validated' do
    assert_match "<span class=\"status_tag validé green\">Validé</span>", @guest_book_decorated.status
  end

  test 'should return correct status tag if not validated' do
    @guest_book.update_attribute(:validated, false)
    assert_match "<span class=\"status_tag non_validé orange\">Non Validé</span>", @guest_book_decorated.status
  end

  private

  def initialize_test
    @guest_book = guest_books(:fr_validate)
    @guest_book_decorated = GuestBookDecorator.new(@guest_book)
  end
end
