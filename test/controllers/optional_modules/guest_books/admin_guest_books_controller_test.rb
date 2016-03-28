# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == GuestBooksController test
  #
  class GuestBooksControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should get show page if logged in' do
      get :show, id: @guest_book
      assert_response :success
    end

    test 'should destroy guest_book' do
      assert_difference ['GuestBook.count'], -1 do
        delete :destroy, id: @guest_book
      end
      assert_redirected_to admin_guest_books_path
    end

    test 'should not access new guest_book page' do
      get :new
      assert_redirected_to admin_dashboard_path
    end

    test 'should not access edit guest_book page' do
      get :edit, id: @guest_book
      assert_redirected_to admin_dashboard_path
    end

    #
    # == Maintenance
    #
    test 'should not render maintenance even if enabled and SA' do
      sign_in @super_administrator
      assert_no_maintenance_backend
    end

    test 'should not render maintenance even if enabled and Admin' do
      sign_in @administrator
      assert_no_maintenance_backend
    end

    test 'should render maintenance if enabled and subscriber' do
      sign_in @subscriber
      assert_maintenance_backend
      assert_redirected_to admin_dashboard_path
    end

    test 'should redirect to login if maintenance and not connected' do
      sign_out @administrator
      assert_maintenance_backend
      assert_redirected_to new_user_session_path
    end

    #
    # == Abilities
    #
    test 'should test abilities for subscriber' do
      sign_in @subscriber
      ability = Ability.new(@subscriber)
      assert ability.cannot?(:create, GuestBook.new), 'should not be able to create'
      assert ability.cannot?(:read, GuestBook.new), 'should not be able to read'
      assert ability.cannot?(:update, GuestBook.new), 'should not be able to update'
      assert ability.cannot?(:destroy, GuestBook.new), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, GuestBook.new), 'should not be able to create'
      assert ability.can?(:read, GuestBook.new), 'should be able to read'
      assert ability.cannot?(:update, GuestBook.new), 'should not be able to update'
      assert ability.can?(:destroy, GuestBook.new), 'should be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, GuestBook.new), 'should not be able to create'
      assert ability.can?(:read, GuestBook.new), 'should be able to read'
      assert ability.cannot?(:update, GuestBook.new), 'should not be able to update'
      assert ability.can?(:destroy, GuestBook.new), 'should be able to destroy'
    end

    #
    # == Subscriber
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@guest_book, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@guest_book, admin_dashboard_path, model_name)
    end

    #
    # == Module disabled
    #
    test 'should not access page if guest_book module is disabled' do
      disable_optional_module @super_administrator, @guest_book_module, 'GuestBook' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@guest_book, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@guest_book, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@guest_book, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @setting = settings(:one)
      @request.env['HTTP_REFERER'] = admin_guest_books_path
      @guest_book = guest_books(:fr_validate)
      @guest_book_not_validate = guest_books(:fr_not_validate)
      @guest_book_module = optional_modules(:guest_book)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
