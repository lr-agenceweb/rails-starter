# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == MapSettingsController test
  #
  class MapSettingsControllerTest < ActionController::TestCase
    include Devise::Test::ControllerHelpers
    include Rails.application.routes.url_helpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should redirect to show page if logged in' do
      get :index
      assert_response 301
      assert_redirected_to admin_map_setting_path(@map_setting)
    end

    test 'should get show page if logged in' do
      get :show, id: @map_setting
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @map_setting
      assert_response :success
    end

    test 'should update map_setting if logged in' do
      patch :update, id: @map_setting
      assert_redirected_to admin_map_setting_path(assigns(:map_setting))
    end

    #
    # == Validation
    #
    test 'should not update if marker_icon is not allowed' do
      patch :update, id: @map_setting, map_setting: { marker_icon: 'bad_value' }
      assert_not assigns(:map_setting).valid?
    end

    test 'should not update if postcode is not numeric' do
      params = { location_attributes: { postcode: 'bad_value' } }
      patch :update, id: @map_setting, map_setting: params
      assert_not assigns(:map_setting).valid?
      assert assigns(:map_setting).errors.keys.include?('location.postcode'.to_sym)
    end

    #
    # == Nested attributes
    #
    test 'should destroy location if destroy is check' do
      location_attrs = {
        id: @map_setting.location.id,
        _destroy: 'true'
      }
      assert @map_setting.location.present?
      assert_difference ['Location.count'], -1 do
        patch :update, id: @map_setting, map_setting: { location_attributes: location_attrs }
        assert assigns(:map_setting).valid?
        @map_setting.reload
        assigns(:map_setting).reload

        assert assigns(:map_setting).location.blank?
        assert @map_setting.location.blank?
      end
    end

    #
    # == Maintenance
    #
    test 'should not render maintenance even if enabled and SA' do
      sign_in @super_administrator
      assert_no_maintenance_backend(:show, @map_setting)
    end

    test 'should not render maintenance even if enabled and Admin' do
      sign_in @administrator
      assert_no_maintenance_backend(:show, @map_setting)
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
      assert ability.cannot?(:create, MapSetting.new), 'should not be able to create'
      assert ability.cannot?(:read, @map_setting), 'should not be able to read'
      assert ability.cannot?(:update, @map_setting), 'should not be able to update'
      assert ability.cannot?(:destroy, @map_setting), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, MapSetting.new), 'should not be able to create'
      assert ability.can?(:read, @map_setting), 'should be able to read'
      assert ability.can?(:update, @map_setting), 'should be able to update'
      assert ability.cannot?(:destroy, @map_setting), 'should not be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, MapSetting.new), 'should not be able to create'
      assert ability.can?(:read, @map_setting), 'should be able to read'
      assert ability.can?(:update, @map_setting), 'should be able to update'
      assert ability.cannot?(:destroy, @map_setting), 'should not be able to destroy'
    end

    #
    # == Destroy
    #
    test 'should not destroy map' do
      assert_no_difference ['MapSetting.count', 'Location.count'] do
        delete :destroy, id: @map_setting
      end
      assert_redirected_to admin_dashboard_path
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@map_setting, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@map_setting, admin_dashboard_path, model_name)
    end

    #
    # == Module disabled
    #
    test 'should not access page if map setting module is disabled' do
      disable_optional_module @super_administrator, @map_module, 'Map' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@map_setting, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@map_setting, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@map_setting, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @setting = settings(:one)
      @map_setting = map_settings(:one)
      @map_module = optional_modules(:map)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
