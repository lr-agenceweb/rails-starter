# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == GuestBookSettingsController test
  #
  class GuestBookSettingsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should get index page if logged in' do
      get :index
      assert_response 301
      assert_redirected_to admin_guest_book_setting_path(@guest_book_setting)
    end

    test 'should get show page if logged in' do
      get :show, id: @guest_book_setting
      assert_response :success
    end

    test 'should be able to edit' do
      get :edit, id: @guest_book_setting
      assert_response :success
    end

    test 'should render 404 if access new page' do
      assert_raises(ActionController::UrlGenerationError) do
        get :new
      end
    end

    test 'should not be able to destroy guest_book setting if subscriber' do
      sign_in @subscriber
      assert_no_difference ['GuestBookSetting.count'] do
        delete :destroy, id: @guest_book_setting
      end
      assert_redirected_to admin_dashboard_path
    end

    test 'should not be able to destroy guest_book setting if admin' do
      assert_no_difference ['GuestBookSetting.count'] do
        delete :destroy, id: @guest_book_setting
      end
      assert_redirected_to admin_dashboard_path
    end

    #
    # == Maintenance
    #
    test 'should still access admin page if maintenance is true' do
      @setting.update_attribute(:maintenance, true)
      get :index
      assert_response 301
      assert_redirected_to admin_guest_book_setting_path(@guest_book_setting)
    end

    test 'should not render maintenance even if enabled and SA' do
      sign_in @super_administrator
      assert_no_maintenance_backend(:show, @guest_book_setting.id)
    end

    test 'should not render maintenance even if enabled and Admin' do
      sign_in @administrator
      assert_no_maintenance_backend(:show, @guest_book_setting.id)
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
      assert ability.cannot?(:create, GuestBookSetting.new), 'should not be able to create'
      assert ability.cannot?(:read, GuestBookSetting.new), 'should not be able to read'
      assert ability.cannot?(:update, GuestBookSetting.new), 'should not be able to update'
      assert ability.cannot?(:destroy, GuestBookSetting.new), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, GuestBookSetting.new), 'should not be able to create'
      assert ability.can?(:read, GuestBookSetting.new), 'should be able to read'
      assert ability.can?(:update, GuestBookSetting.new), 'should be able to update'
      assert ability.cannot?(:destroy, GuestBookSetting.new), 'should not be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, GuestBookSetting.new), 'should not be able to create'
      assert ability.can?(:read, GuestBookSetting.new), 'should be able to read'
      assert ability.can?(:update, GuestBookSetting.new), 'should be able to update'
      assert ability.cannot?(:destroy, GuestBookSetting.new), 'should not be able to destroy'
    end

    #
    # == Subscriber
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@guest_book_setting, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@guest_book_setting, admin_dashboard_path, model_name, no_index: true)
    end

    #
    # == Module disabled
    #
    test 'should not access page if guest_book module is disabled' do
      disable_optional_module @super_administrator, @guest_book_module, 'GuestBookSetting' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@guest_book_setting, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@guest_book_setting, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@guest_book_setting, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @guest_book_setting = guest_book_settings(:one)
      @guest_book_module = optional_modules(:guest_book)
      @setting = settings(:one)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
