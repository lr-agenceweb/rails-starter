# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == MailingSettingsController test
  #
  class MailingSettingsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should redirect index page to show if logged in' do
      get :index
      assert_response 301
      assert_redirected_to admin_mailing_setting_path(@mailing_setting)
    end

    test 'should get show page if logged in' do
      get :show, id: @mailing_setting
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @mailing_setting
      assert_response :success
    end

    test 'should update mailing_setting if logged in' do
      patch :update, id: @mailing_setting, mailing_setting: {}
      assert_redirected_to admin_mailing_setting_path(@mailing_setting)
    end

    test 'should save if email is blank' do
      patch :update, id: @mailing_setting, mailing_setting: { email: '' }
      assert assigns(:mailing_setting).valid?
    end

    test 'should not save if email is set but not correct' do
      patch :update, id: @mailing_setting, mailing_setting: { email: 'mail' }
      assert_not assigns(:mailing_setting).valid?
    end

    test 'should save if email is correct' do
      patch :update, id: @mailing_setting, mailing_setting: { email: 'mailing@test.com' }
      assert assigns(:mailing_setting).valid?
    end

    #
    # == Destroy
    #
    test 'should not destroy if logged in as subscriber' do
      sign_in @subscriber
      assert_no_difference 'MailingSetting.count' do
        delete :destroy, id: @mailing_setting
      end
    end

    test 'should not destroy if logged in as administrator' do
      assert_no_difference 'MailingSetting.count' do
        delete :destroy, id: @mailing_setting
      end
    end

    #
    # == Subscriber
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@mailing_setting, new_user_session_path, model_name, no_show: true)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@mailing_setting, admin_dashboard_path, model_name, no_show: true)
    end

    #
    # == Maintenance
    #
    test 'should not render maintenance even if enabled and SA' do
      sign_in @super_administrator
      assert_no_maintenance_backend(:show, @mailing_setting.id)
    end

    test 'should not render maintenance even if enabled and Admin' do
      sign_in @administrator
      assert_no_maintenance_backend(:show, @mailing_setting.id)
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
      assert ability.cannot?(:create, MailingSetting.new), 'should not be able to create'
      assert ability.cannot?(:read, @mailing_setting), 'should not be able to read'
      assert ability.cannot?(:update, @mailing_setting), 'should not be able to update'
      assert ability.cannot?(:destroy, @mailing_setting), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, MailingSetting.new), 'should not be able to create'
      assert ability.can?(:read, @mailing_setting), 'should be able to read'
      assert ability.can?(:update, @mailing_setting), 'should be able to update'
      assert ability.cannot?(:destroy, @mailing_setting), 'should not be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, MailingSetting.new), 'should not be able to create'
      assert ability.can?(:read, @mailing_setting), 'should be able to read'
      assert ability.can?(:update, @mailing_setting), 'should be able to update'
      assert ability.cannot?(:destroy, @mailing_setting), 'should not be able to destroy'
    end

    #
    # == Module disabled
    #
    test 'should not access page if mailing module is disabled' do
      disable_optional_module @super_administrator, @mailing_module, 'Mailing' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@mailing_setting, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@mailing_setting, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@mailing_setting, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @setting = settings(:one)
      @mailing_setting = mailing_settings(:one)
      @mailing_module = optional_modules(:mailing)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
