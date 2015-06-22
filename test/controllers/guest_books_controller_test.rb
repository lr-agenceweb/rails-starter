require 'test_helper'

#
# == GuestBooksController Test
#
class GuestBooksControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup :initialize_test

  # Actions
  test 'should get index' do
    I18n.available_locales.each do |locale|
      get :index, locale: locale.to_s
      assert_response :success
    end
  end

  # Template
  test 'should use index template' do
    I18n.available_locales.each do |locale|
      get :index, locale: locale.to_s
      assert_template :index
    end
  end

  # Ajax
  test 'should get index by ajax' do
    I18n.available_locales.each do |locale|
      xhr :get, :index, format: :js, locale: locale.to_s
      assert_response :success
    end
  end

  test 'should use index template by ajax' do
    I18n.available_locales.each do |locale|
      xhr :get, :index, format: :js, locale: locale.to_s
      assert_template :index
    end
  end

  test 'should fetch only online validated messages' do
    @guest_books = GuestBook.validated
    assert_equal @guest_books.length, 2
  end

  test 'should get guest_books page by url' do
    assert_routing '/livre-d-or', controller: 'guest_books', action: 'index', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/guest-book', controller: 'guest_books', action: 'index', locale: 'en' if @locales.include?(:en)
  end

  private

  def initialize_test
    @locales = I18n.available_locales
  end
end
