# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == NewsletterSettingsController test
  #
  class NewsletterSettingsControllerTest < ActionController::TestCase
    include Devise::Test::ControllerHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should get index page if logged in' do
      get :index
      assert_redirected_to admin_newsletter_setting_path(@newsletter_setting)
    end

    test 'should get edit page if logged in' do
      get :edit, params: { id: @newsletter_setting }
      assert_response :success
    end

    # Valid params
    test 'should update newsletter_setting if logged in' do
      patch :update, params: { id: @newsletter_setting, newsletter_setting: {} }
      assert_redirected_to admin_newsletter_setting_path
    end

    #
    # == Destroy
    #
    test 'should not destroy user if logged in as subscriber' do
      assert_no_difference 'NewsletterSetting.count' do
        delete :destroy, params: { id: @newsletter_setting }
      end
    end

    #
    # == Subscriber
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@newsletter_setting, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@newsletter_setting, admin_dashboard_path, model_name)
    end

    #
    # == Maintenance
    #
    test 'should not render maintenance even if enabled and SA' do
      sign_in @super_administrator
      assert_no_maintenance_backend(:show, @newsletter_setting)
    end

    test 'should not render maintenance even if enabled and Admin' do
      sign_in @administrator
      assert_no_maintenance_backend(:show, @newsletter_setting)
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
      assert ability.cannot?(:create, NewsletterSetting.new), 'should not be able to create'
      assert ability.cannot?(:read, @newsletter_setting), 'should not be able to read'
      assert ability.cannot?(:update, @newsletter_setting), 'should not be able to update'
      assert ability.cannot?(:destroy, @newsletter_setting), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, NewsletterSetting.new), 'should not be able to create'
      assert ability.can?(:read, @newsletter_setting), 'should be able to read'
      assert ability.can?(:update, @newsletter_setting), 'should be able to update'
      assert ability.cannot?(:destroy, @newsletter_setting), 'should not be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, NewsletterSetting.new), 'should not be able to create'
      assert ability.can?(:read, @newsletter_setting), 'should be able to read'
      assert ability.can?(:update, @newsletter_setting), 'should be able to update'
      assert ability.cannot?(:destroy, @newsletter_setting), 'should not be able to destroy'
    end

    #
    # == Module disabled
    #
    test 'should not access page if newsletter module is disabled' do
      disable_optional_module @super_administrator, @newsletter_module, 'Newsletter' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@newsletter_setting, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@newsletter_setting, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@newsletter_setting, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @setting = settings(:one)
      @newsletter_setting = newsletter_settings(:one)
      @newsletter_module = optional_modules(:newsletter)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
