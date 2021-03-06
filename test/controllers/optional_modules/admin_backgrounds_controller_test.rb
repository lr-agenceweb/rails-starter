# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == BackgroundsController test
  #
  class BackgroundsControllerTest < ActionController::TestCase
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
      get :show, params: { id: @background }
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, params: { id: @background }
      assert_response :success
    end

    test 'should update page if logged in' do
      patch :update, params: { id: @background, background: {} }
      assert_redirected_to admin_background_path(@background)
    end

    test 'should destroy background' do
      assert_difference 'Background.count', -1 do
        delete :destroy, params: { id: @background }
      end
      assert_redirected_to admin_backgrounds_path
    end

    #
    # == Form validations
    #
    test 'should save background after switching page' do
      patch :update, params: { id: @background, background: { attachable_id: 4 } }
      assert_equal 4, assigns(:background).attachable_id
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@background, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@background, admin_dashboard_path, model_name)
    end

    #
    # == Module disabled
    #
    test 'should not access page if background module is disabled' do
      disable_optional_module @super_administrator, @background_module, 'Background' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@background, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@background, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@background, admin_dashboard_path, model_name)
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
      assert ability.cannot?(:create, Background.new), 'should not be able to create'
      assert ability.cannot?(:read, @background), 'should not be able to read'
      assert ability.cannot?(:update, @background), 'should not be able to update'
      assert ability.cannot?(:destroy, @background), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.can?(:create, Background.new), 'should be able to create'
      assert ability.can?(:read, @background), 'should be able to read'
      assert ability.can?(:update, @background), 'should be able to update'
      assert ability.can?(:destroy, @background), 'should be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, Background.new), 'should be able to create'
      assert ability.can?(:read, @background), 'should be able to read'
      assert ability.can?(:update, @background), 'should be able to update'
      assert ability.can?(:destroy, @background), 'should be able to destroy'
    end

    #
    # == Background
    #
    test 'should update background if new picture is sent' do
      attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
      patch :update, params: { id: @background, background: { image: attachment } }
      background = assigns(:background)
      assert_equal background.image_file_name, 'background-paris.jpg'
      assert_equal background.image_content_type, 'image/jpeg'
      delete :destroy, params: { id: background.id }
    end

    test 'should destroy all attachments when destroying background' do
      attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
      patch :update, params: { id: @background, background: { image: attachment } }

      background = assigns(:background)
      existing_styles = []
      background.image.styles.keys.collect do |style|
        f = background.image.path(style)
        assert File.exist?(f), "File #{f} should exist"
        existing_styles << f
      end

      delete :destroy, params: { id: background.id }
      existing_styles.each do |f|
        assert_not File.exist?(f), "File #{f} should not exist"
      end
    end

    private

    def initialize_test
      @setting = settings(:one)

      @background = backgrounds(:home)
      @background_module = optional_modules(:background)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
