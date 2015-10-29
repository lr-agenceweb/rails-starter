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
      @event_settings = event_settings(:one)
      @event_module = optional_modules(:event)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
