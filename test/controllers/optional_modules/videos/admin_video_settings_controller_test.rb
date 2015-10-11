require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == VideoSettingsController test
  #
  class VideoSettingsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

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
      @video_settings = video_settings(:one)
      @video_module = optional_modules(:video)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
