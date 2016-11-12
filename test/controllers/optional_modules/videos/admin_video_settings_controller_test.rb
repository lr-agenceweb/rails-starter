# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == VideoSettingsController test
  #
  class VideoSettingsControllerTest < ActionController::TestCase
    include Devise::Test::ControllerHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should get index page if logged in' do
      get :index
      assert_response 301
      assert_redirected_to admin_video_setting_path(@video_settings)
    end

    test 'should get show page if logged in' do
      get :show, id: @video_settings
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @video_settings
      assert_response :success
    end

    test 'should update category if logged in' do
      patch :update, id: @video_settings, video_setting: {}
      assert_redirected_to admin_video_setting_path(@video_settings)
    end

    test 'should not destroy background' do
      assert_no_difference 'VideoSetting.count' do
        delete :destroy, id: @video_settings
      end
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@video_settings, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@video_settings, admin_dashboard_path, model_name)
    end

    #
    # == Module disabled
    #
    test 'should not access page if video module is disabled' do
      disable_optional_module @super_administrator, @video_module, 'Video' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@video_settings, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@video_settings, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@video_settings, admin_dashboard_path, model_name)
    end

    #
    # == VideoBackground
    #
    test 'should remove video_background boolean if administrator' do
      patch :update, id: @video_settings, video_setting: { video_background: '0' }
      assert assigns(:video_setting).video_background?
    end

    test 'should keep video_background boolean if super_administrator' do
      sign_in @super_administrator
      patch :update, id: @video_settings, video_setting: { video_background: '0' }
      assert_not assigns(:video_setting).video_background?
    end

    #
    # == Maintenance
    #
    test 'should not render maintenance even if enabled and SA' do
      sign_in @super_administrator
      assert_no_maintenance_backend(:show, @video_settings)
    end

    test 'should not render maintenance even if enabled and Admin' do
      sign_in @administrator
      assert_no_maintenance_backend(:show, @video_settings)
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
      assert ability.cannot?(:create, VideoSetting.new), 'should not be able to create'
      assert ability.cannot?(:read, @video_settings), 'should not be able to read'
      assert ability.cannot?(:update, @video_settings), 'should not be able to update'
      assert ability.cannot?(:destroy, @video_settings), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, VideoSetting.new), 'should not be able to create'
      assert ability.can?(:read, @video_settings), 'should be able to read'
      assert ability.can?(:update, @video_settings), 'should be able to update'
      assert ability.cannot?(:destroy, @video_settings), 'should not be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, VideoSetting.new), 'should not be able to create'
      assert ability.can?(:read, @video_settings), 'should be able to read'
      assert ability.can?(:update, @video_settings), 'should be able to update'
      assert ability.cannot?(:destroy, @video_settings), 'should not be able to destroy'
    end

    private

    def initialize_test
      @setting = settings(:one)
      @video_settings = video_settings(:one)
      @video_module = optional_modules(:video)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
