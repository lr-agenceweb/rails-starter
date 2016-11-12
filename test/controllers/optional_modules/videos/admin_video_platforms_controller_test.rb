# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == VideoPlatformsController test
  #
  class VideoPlatformsControllerTest < ActionController::TestCase
    include Devise::Test::ControllerHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should get show page if logged in' do
      get :show, id: @video_platform
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @video_platform
      assert_response :success
    end

    test 'should update category if logged in' do
      patch :update, id: @video_platform, video_platform: {}
      assert_redirected_to admin_video_platform_path(@video_platform)
    end

    test 'should destroy VideoPlatform' do
      assert_difference 'VideoPlatform.count', -1 do
        delete :destroy, id: @video_platform
      end
      assert_redirected_to admin_video_platforms_path
    end

    #
    # == Batch actions
    #
    test 'should return correct value for toggle_online batch action' do
      post :batch_action, batch_action: 'toggle_online', collection_selection: [@video_platform.id]
      [@video_platform].each(&:reload)
      assert_not @video_platform.online?
    end

    test 'should redirect to back and have correct flash notice for toggle_online batch action' do
      post :batch_action, batch_action: 'toggle_online', collection_selection: [@video_platform.id]
      assert_redirected_to admin_video_platforms_path
      assert_equal I18n.t('active_admin.batch_actions.flash'), flash[:notice]
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@video_platform, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@video_platform, admin_dashboard_path, model_name)
    end

    #
    # == Module disabled
    #
    test 'should not access page if video module is disabled' do
      disable_optional_module @super_administrator, @video_module, 'Video' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@video_platform, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@video_platform, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@video_platform, admin_dashboard_path, model_name)
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
      assert ability.cannot?(:create, VideoPlatform.new), 'should not be able to create'
      assert ability.cannot?(:read, @video_platform), 'should not be able to read'
      assert ability.cannot?(:update, @video_platform), 'should not be able to update'
      assert ability.cannot?(:destroy, @video_platform), 'should not be able to destroy'

      assert ability.cannot?(:toggle_online, @video_platform), 'should not be able to toggle_online'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, VideoPlatform.new), 'should not be able to create'
      assert ability.can?(:read, @video_platform), 'should be able to read'
      assert ability.can?(:update, @video_platform), 'should be able to update'
      assert ability.can?(:destroy, @video_platform), 'should be able to destroy'

      assert ability.can?(:toggle_online, @video_platform), 'should be able to toggle_online'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, VideoPlatform.new), 'should not be able to create'
      assert ability.can?(:read, @video_platform), 'should be able to read'
      assert ability.can?(:update, @video_platform), 'should be able to update'
      assert ability.can?(:destroy, @video_platform), 'should be able to destroy'

      assert ability.can?(:toggle_online, @video_platform), 'should be able to toggle_online'
    end

    test 'should test abilities for administrator with video_platform disabled' do
      disable_video_platform_settings
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, VideoPlatform.new), 'should not be able to create'
      assert ability.cannot?(:read, @video_platform), 'should not be able to read'
      assert ability.cannot?(:update, @video_platform), 'should not be able to update'
      assert ability.cannot?(:destroy, @video_platform), 'should not be able to destroy'
    end

    test 'should test abilities for super_administrator with video_platform disabled' do
      disable_video_platform_settings
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, VideoPlatform.new), 'should not be able to create'
      assert ability.cannot?(:read, @video_platform), 'should not be able to read'
      assert ability.cannot?(:update, @video_platform), 'should not be able to update'
      assert ability.cannot?(:destroy, @video_platform), 'should not be able to destroy'
    end

    private

    def initialize_test
      @setting = settings(:one)
      @request.env['HTTP_REFERER'] = admin_video_platforms_path

      @video_settings = video_settings(:one)
      @video_module = optional_modules(:video)
      @video_platform = video_platforms(:one)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end

    def disable_video_platform_settings
      @controller = Admin::VideoSettingsController.new
      assert @video_settings.video_platform?
      patch :update, id: @video_settings, video_setting: { video_platform: '0' }
      assert_not assigns(:video_setting).video_platform?
    end
  end
end
