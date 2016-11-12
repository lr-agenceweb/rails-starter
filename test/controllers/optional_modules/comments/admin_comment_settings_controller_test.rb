# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == CommentSettingsController test
  #
  class CommentSettingsControllerTest < ActionController::TestCase
    include Devise::Test::ControllerHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should get index page if logged in' do
      get :index
      assert_response 301
      assert_redirected_to admin_comment_setting_path(@comment_setting)
    end

    test 'should get show page if logged in' do
      get :show, id: @comment_setting
      assert_response :success
    end

    test 'should be able to edit' do
      get :edit, id: @comment_setting
      assert_response :success
    end

    test 'should render 404 if access new page' do
      assert_raises(ActionController::UrlGenerationError) do
        get :new
      end
    end

    test 'should not be able to destroy comment setting if subscriber' do
      sign_in @subscriber
      assert_no_difference ['CommentSetting.count'] do
        delete :destroy, id: @comment_setting
      end
      assert_redirected_to admin_dashboard_path
    end

    test 'should not be able to destroy comment setting if admin' do
      assert_no_difference ['CommentSetting.count'] do
        delete :destroy, id: @comment_setting
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
      assert_redirected_to admin_comment_setting_path(@comment_setting)
    end

    test 'should not render maintenance even if enabled and SA' do
      sign_in @super_administrator
      assert_no_maintenance_backend(:show, @comment_setting.id)
    end

    test 'should not render maintenance even if enabled and Admin' do
      sign_in @administrator
      assert_no_maintenance_backend(:show, @comment_setting.id)
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
      assert ability.cannot?(:create, CommentSetting.new), 'should not be able to create'
      assert ability.cannot?(:read, @comment_setting), 'should not be able to read'
      assert ability.cannot?(:update, @comment_setting), 'should not be able to update'
      assert ability.cannot?(:destroy, @comment_setting), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, CommentSetting.new), 'should not be able to create'
      assert ability.can?(:read, @comment_setting), 'should be able to read'
      assert ability.can?(:update, @comment_setting), 'should be able to update'
      assert ability.cannot?(:destroy, @comment_setting), 'should not be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, CommentSetting.new), 'should not be able to create'
      assert ability.can?(:read, @comment_setting), 'should be able to read'
      assert ability.can?(:update, @comment_setting), 'should be able to update'
      assert ability.cannot?(:destroy, @comment_setting), 'should not be able to destroy'
    end

    #
    # == Subscriber
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@comment_setting, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@comment_setting, admin_dashboard_path, model_name, no_index: true)
    end

    #
    # == Module disabled
    #
    test 'should not access page if comment module is disabled' do
      disable_optional_module @super_administrator, @comment_module, 'Comment' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@comment_setting, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@comment_setting, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@comment_setting, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @comment_setting = comment_settings(:one)
      @comment_module = optional_modules(:comment)
      @setting = settings(:one)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
