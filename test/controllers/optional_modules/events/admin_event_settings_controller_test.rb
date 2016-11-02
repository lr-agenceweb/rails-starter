# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == EventSettingsController test
  #
  class EventSettingsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should get index page if logged in' do
      get :index
      assert_response 301
      assert_redirected_to admin_event_setting_path(@event_settings)
    end

    test 'should get show page if logged in' do
      get :show, id: @event_settings
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @event_settings
      assert_response :success
    end

    test 'should update event_setting if logged in' do
      patch :update, id: @event_settings, event_setting: {}
      assert_redirected_to admin_event_setting_path(@event_settings)
    end

    test 'should not destroy background' do
      assert_no_difference 'EventSetting.count' do
        delete :destroy, id: @event_settings
      end
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@event_settings, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@event_settings, admin_dashboard_path, model_name)
    end

    #
    # == Map module
    #
    test 'should not update show_map setting if map module is disabled' do
      disable_optional_module @super_administrator, @map_module, 'Map' # in test_helper.rb
      sign_in @administrator

      assert_not @event_settings.show_map?
      patch :update, id: @event_settings, event_setting: { show_map: true }
      assert assigns(:event_setting).valid?
      assert_not assigns(:event_setting).show_map?, 'map should not change of status'
    end

    test 'should update show_map setting if map module is enabled' do
      assert_not @event_settings.show_map?
      patch :update, id: @event_settings, event_setting: { show_map: true }
      assert assigns(:event_setting).valid?
      assert assigns(:event_setting).show_map?, 'map should have changed of status'
    end

    #
    # == Calendar module
    #
    test 'should not update show_calendar setting if calendar module is disabled' do
      disable_optional_module @super_administrator, @calendar_module, 'Calendar' # in test_helper.rb
      sign_in @administrator

      assert_not @event_settings.show_calendar?
      patch :update, id: @event_settings, event_setting: { show_calendar: true }
      assert assigns(:event_setting).valid?
      assert_not assigns(:event_setting).show_calendar?, 'calendar should not change of status'
    end

    test 'should update show_calendar setting if calendar module is enabled' do
      assert_not @event_settings.show_calendar?
      patch :update, id: @event_settings, event_setting: { show_calendar: true }
      assert assigns(:event_setting).valid?
      assert assigns(:event_setting).show_calendar?, 'calendar should have changed of status'
    end

    #
    # == Module disabled
    #
    test 'should not access page if event module is disabled' do
      disable_optional_module @super_administrator, @event_module, 'Event' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@event_settings, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@event_settings, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@event_settings, admin_dashboard_path, model_name)
    end

    #
    # == Maintenance
    #
    test 'should not render maintenance even if enabled and SA' do
      sign_in @super_administrator
      assert_no_maintenance_backend(:show, @event_settings)
    end

    test 'should not render maintenance even if enabled and Admin' do
      sign_in @administrator
      assert_no_maintenance_backend(:show, @event_settings)
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
      assert ability.cannot?(:create, EventSetting.new), 'should not be able to create'
      assert ability.cannot?(:read, @event_settings), 'should not be able to read'
      assert ability.cannot?(:update, @event_settings), 'should not be able to update'
      assert ability.cannot?(:destroy, @event_settings), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, EventSetting.new), 'should not be able to create'
      assert ability.can?(:read, @event_settings), 'should be able to read'
      assert ability.can?(:update, @event_settings), 'should be able to update'
      assert ability.cannot?(:destroy, @event_settings), 'should not be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, EventSetting.new), 'should not be able to create'
      assert ability.can?(:read, @event_settings), 'should be able to read'
      assert ability.can?(:update, @event_settings), 'should be able to update'
      assert ability.cannot?(:destroy, @event_settings), 'should not be able to destroy'
    end

    private

    def initialize_test
      @setting = settings(:one)
      @event_settings = event_settings(:one)

      @event_module = optional_modules(:event)
      @map_module = optional_modules(:map)
      @calendar_module = optional_modules(:calendar)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
