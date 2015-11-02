require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == AdultSettingsController test
  #
  class AdultSettingsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should get index page if logged in' do
      get :index
      assert_redirected_to admin_adult_setting_path(@adult_setting)
    end

    test 'should get edit page if logged in' do
      get :edit, id: @adult_setting
      assert_response :success
    end

    # Valid params
    test 'should update adult_setting if logged in' do
      patch :update, id: @adult_setting, adult_setting: {}
      assert_redirected_to admin_adult_setting_path
    end

    #
    # == Destroy
    #
    test 'should not destroy adult_setting if logged in as subscriber' do
      assert_no_difference 'AdultSetting.count' do
        delete :destroy, id: @adult_setting
      end
    end

    #
    # == Subscriber
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@adult_setting, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@adult_setting, admin_dashboard_path, model_name)
    end

    #
    # == Abilities
    #
    test 'should test abilities for subscriber' do
      sign_in @subscriber
      ability = Ability.new(@subscriber)
      assert ability.cannot?(:create, AdultSetting.new), 'should not be able to create'
      assert ability.cannot?(:read, @adult_setting), 'should not be able to read'
      assert ability.cannot?(:update, @adult_setting), 'should not be able to update'
      assert ability.cannot?(:destroy, @adult_setting), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, AdultSetting.new), 'should not be able to create'
      assert ability.can?(:read, @adult_setting), 'should be able to read'
      assert ability.can?(:update, @adult_setting), 'should be able to update'
      assert ability.cannot?(:destroy, @adult_setting), 'should not be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, AdultSetting.new), 'should not be able to create'
      assert ability.can?(:read, @adult_setting), 'should be able to read'
      assert ability.can?(:update, @adult_setting), 'should be able to update'
      assert ability.cannot?(:destroy, @adult_setting), 'should not be able to destroy'
    end

    #
    # == Module disabled
    #
    test 'should not access page if adult module is disabled' do
      disable_optional_module @super_administrator, @adult_module, 'Adult' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@adult_setting, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@adult_setting, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@adult_setting, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @adult_setting = adult_settings(:one)
      @adult_module = optional_modules(:adult)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
