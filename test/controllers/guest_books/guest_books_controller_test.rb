require 'test_helper'

#
# == GuestBooksController Test
#
class GuestBooksControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include Rails.application.routes.url_helpers

  setup :initialize_test

  #
  # == Actions
  #
  test 'should get index' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, locale: locale.to_s
        assert_response :success
      end
    end
  end

  test 'should create message if params are properly filled' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_difference ['GuestBook.count'], 1 do
          post :create, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas@test.com', content: 'Merci !', lang: locale.to_s }
        end
        assert assigns(:guest_book).valid?
      end
    end
  end

  test 'should not create message if params are empty' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_no_difference ['GuestBook.count'] do
          post :create, locale: locale.to_s, guest_book: { username: '' }
        end
        assert_not assigns(:guest_book).valid?
      end
    end
  end

  test 'should not create message if email is not properly formatted' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_no_difference ['GuestBook.count'] do
          post :create, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas', content: 'Merci !', lang: locale.to_s }
        end
        assert_not assigns(:guest_book).valid?
      end
    end
  end

  test 'should not create message if lang params is not allowed' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_no_difference ['GuestBook.count'] do
          post :create, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas@test.com',  content: 'Merci !', lang: 'ja' }
        end
        assert_not assigns(:guest_book).valid?
      end
    end
  end

  test 'should not create message if nickname is filled' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_no_difference ['GuestBook.count'] do
          post :create, locale: locale.to_s, guest_book:  { username: 'Lucas', email: 'lucas@test.com', content: 'Merci !', lang: locale.to_s, nickname: 'spammer' }
        end
        assert_not assigns(:guest_book).valid?
        assert_redirected_to guest_books_path
      end
    end
  end

  test 'should not appears on site if setting should_validate is true' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        post :create, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas@test.com', content: 'Merci !', lang: locale.to_s }
        assert_not assigns(:guest_book).validated
      end
    end
  end

  #
  # == Template
  #
  test 'should use index template' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, locale: locale.to_s
        assert_template :index
      end
    end
  end

  #
  # == Ajax
  #
  test 'AJAX :: should get index' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :get, :index, format: :js, locale: locale.to_s
        assert_response :success
      end
    end
  end

  test 'AJAX :: should use index template' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :get, :index, format: :js, locale: locale.to_s
        assert_template :index
      end
    end
  end

  test 'AJAX :: should create message if params are properly filled' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_difference ['GuestBook.count'], 1 do
          xhr :post, :create, format: :js, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas@test.com', content: 'Merci !', lang: locale.to_s }
        end
        assert assigns(:guest_book).valid?
      end
    end
  end

  test 'AJAX :: should not create message if lang params is not allowed' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_no_difference ['GuestBook.count'] do
          xhr :post, :create, format: :js, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas@test.com', content: 'Merci !', lang: 'ja' }
        end
        assert_not assigns(:guest_book).valid?
      end
    end
  end

  test 'AJAX :: should not create message if nickname is filled' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_no_difference ['GuestBook.count'] do
          xhr :post, :create, format: :js, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas@test.com', content: 'Merci !', lang: locale.to_s, nickname: 'spammer' }
        end
        assert_not assigns(:guest_book).valid?
        assert_template :captcha
      end
    end
  end

  test 'AJAX :: should not appears on site if setting should_validate is true' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :post, :create, format: :js, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas@test.com', content: 'Merci !', lang: locale.to_s }
        assert_not assigns(:guest_book).validated
      end
    end
  end

  #
  # == Conditionals
  #
  test 'should fetch only validated messages' do
    @guest_books = GuestBook.validated
    assert_equal @guest_books.length, 3
  end

  test 'should fetch only messages from current locale' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        @guest_books = GuestBook.by_locale(locale.to_s)
        assert_equal @guest_books.length, 3 if locale == 'fr'
        assert_equal @guest_books.length, 2 if locale == 'en'
      end
    end
  end

  test 'should fetch only messages from current locale and validated' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        @guest_books = GuestBook.validated.by_locale(locale.to_s)
        assert_equal @guest_books.length, 2 if locale == 'fr'
        assert_equal @guest_books.length, 1 if locale == 'en'
      end
    end
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
