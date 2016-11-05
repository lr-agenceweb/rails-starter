# frozen_string_literal: true
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

  test 'should create if params are properly filled' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_difference ['GuestBook.count'], 1 do
          post :create, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas@test.com', content: 'Merci !', lang: locale.to_s }
        end
        assert assigns(:guest_book).valid?
      end
    end
  end

  test 'should not create if params are empty' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_no_difference ['GuestBook.count'] do
          post :create, locale: locale.to_s, guest_book: { username: '' }
        end
        assert_not assigns(:guest_book).valid?
      end
    end
  end

  test 'should not create if email is not properly formatted' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_no_difference ['GuestBook.count'] do
          post :create, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas', content: 'Merci !', lang: locale.to_s }
        end
        assert_not assigns(:guest_book).valid?
      end
    end
  end

  test 'should not create if lang params is not allowed' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_no_difference ['GuestBook.count'] do
          post :create, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas@test.com', content: 'Merci !', lang: 'ja' }
        end
        assert_not assigns(:guest_book).valid?
      end
    end
  end

  test 'should not create if nickname is filled' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_no_difference ['GuestBook.count'] do
          post :create, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas@test.com', content: 'Merci !', lang: locale.to_s, nickname: 'spammer' }
        end
        assert_not assigns(:guest_book).valid?
        assert_redirected_to guest_books_path
      end
    end
  end

  test 'should not appears if should_validate is true' do
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

  test 'AJAX :: should create if params are properly filled' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_difference ['GuestBook.count'], 1 do
          xhr :post, :create, format: :js, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas@test.com', content: 'Merci !', lang: locale.to_s }
        end
        assert assigns(:guest_book).valid?
      end
    end
  end

  test 'AJAX :: should not create if lang params is not allowed' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_no_difference ['GuestBook.count'] do
          xhr :post, :create, format: :js, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas@test.com', content: 'Merci !', lang: 'ja' }
        end
        assert_not assigns(:guest_book).valid?
      end
    end
  end

  test 'AJAX :: should not create if nickname is filled' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_no_difference ['GuestBook.count'] do
          xhr :post, :create, format: :js, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas@test.com', content: 'Merci !', lang: locale.to_s, nickname: 'spammer' }
        end
        assert_not assigns(:guest_book).valid?
      end
    end
  end

  test 'AJAX :: should not appears if should_validate is true' do
    @guest_book_setting.update_attribute(:should_validate, true)
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :post, :create, format: :js, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas@test.com', content: 'Merci !', lang: locale.to_s }
        assert_not assigns(:guest_book).validated
      end
    end
  end

  #
  # == Flash
  #
  test 'should have correct flash if should validate' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        post :create, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas@test.com', content: 'Merci !', lang: locale.to_s }
        assert_equal I18n.t('comment.create_success_with_validate'), flash[:success]
      end
    end
  end

  test 'should have correct flash if should not validate' do
    @guest_book_setting.update_attribute(:should_validate, false)
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        post :create, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas@test.com', content: 'Merci !', lang: locale.to_s }
        assert_equal I18n.t('comment.create_success'), flash[:success]
      end
    end
  end

  test 'AJAX :: should have correct flash if should validate' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :post, :create, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas@test.com', content: 'Merci !', lang: locale.to_s }
        assert_equal I18n.t('comment.create_success_with_validate'), flash[:success]
      end
    end
  end

  test 'AJAX :: should have correct flash if should not validate' do
    @guest_book_setting.update_attribute(:should_validate, false)
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        xhr :post, :create, locale: locale.to_s, guest_book: { username: 'Lucas', email: 'lucas@test.com', content: 'Merci !', lang: locale.to_s }
        assert_equal I18n.t('comment.create_success'), flash[:success]
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

  test 'should fetch only from current locale and validated' do
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

  #
  # == Module disabled
  #
  test 'should render 404 if module is disabled' do
    disable_optional_module @super_administrator, @guest_book_module, 'GuestBook' # in test_helper.rb
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_raises(ActionController::RoutingError) do
          get :index, locale: locale.to_s
        end
      end
    end
  end

  #
  # == Menu offline
  #
  test 'should render 404 if menu item is offline' do
    @menu.update_attribute(:online, false)
    assert_not @menu.online, 'menu item should be offline'

    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_raises(ActionController::RoutingError) do
          get :index, locale: locale.to_s
        end
      end
    end
  end

  #
  # == Maintenance
  #
  test 'should render maintenance if enabled and not connected' do
    assert_maintenance_frontend
  end

  test 'should not render maintenance even if enabled and SA' do
    sign_in @super_administrator
    assert_no_maintenance_frontend
  end

  test 'should not render maintenance even if enabled and Admin' do
    sign_in @administrator
    assert_no_maintenance_frontend
  end

  test 'should render maintenance if enabled and subscriber' do
    sign_in @subscriber
    assert_maintenance_frontend
  end

  private

  def initialize_test
    @guest_book = guest_books(:fr_validate)
    @guest_book_module = optional_modules(:guest_book)
    @guest_book_setting = guest_book_settings(:one)

    @locales = I18n.available_locales
    @setting = settings(:one)
    @menu = menus(:guest_book)

    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)
  end
end
