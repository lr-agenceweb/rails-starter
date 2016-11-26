# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == SettingsController test
  #
  class SettingsControllerTest < ActionController::TestCase
    include Devise::Test::ControllerHelpers

    setup :initialize_test

    #
    # Routing
    # =========
    test 'should redirect index to show if logged in' do
      get :index
      assert_response 301
      assert_redirected_to admin_setting_path(@setting)
    end

    test 'should show show page if logged in' do
      get :show, params: { id: @setting }
      assert_response :success
    end

    test 'should show edit page if logged in' do
      get :edit, params: { id: @setting }
      assert_response :success
    end

    test 'should update setting if logged in' do
      patch :update, params: { id: @setting, setting: {} }
      assert_redirected_to admin_setting_path(@setting)
    end

    test 'should render 404 if access new page' do
      assert_raises(ActionController::UrlGenerationError) do
        get :new
      end
    end

    test 'should render 404 if access destroy page' do
      assert_raises(ActionController::UrlGenerationError) do
        delete :destroy
      end
    end

    #
    # Maintenance
    # ===============
    test 'should still access admin page if maintenance is true' do
      @setting.update_attribute(:maintenance, true)
      get :index
      assert_response 301
      assert_redirected_to admin_setting_path(@setting)
    end

    test 'should not render maintenance even if enabled and SA' do
      sign_in @super_administrator
      assert_no_maintenance_backend(:show, 1)
    end

    test 'should not render maintenance even if enabled and Admin' do
      sign_in @administrator
      assert_no_maintenance_backend(:show, 1)
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
    # Form validations
    # ===================
    test 'should not update setting without name' do
      patch :update, params: { id: @setting, setting: { name: nil } }
      assert_not assigns(:setting).valid?
      assert_equal [:name], assigns(:setting).errors.keys
    end

    test 'should not update setting without title' do
      attrs = { translations_attributes: { '1': { title: nil }, '0': { title: nil } } }
      patch :update, params: { id: @setting, setting: attrs }

      assert_not assigns(:setting).valid?
      assert_equal [:'translations.locale', :'translations.title'], assigns(:setting).errors.keys
    end

    test 'should not update social param if module is disabled' do
      disable_optional_module @super_administrator, @social_module, 'Social' # in test_helper.rb
      sign_in @administrator
      patch :update, params: { id: @setting, setting: { show_social: '1' } }
      assert_not assigns(:setting).show_social?
    end

    test 'should not update breadcrumb param if module is disabled' do
      disable_optional_module @super_administrator, @breadcrumb_module, 'Breadcrumb' # in test_helper.rb
      sign_in @administrator
      patch :update, params: { id: @setting, setting: { show_breadcrumb: '1' } }
      assert_not assigns(:setting).show_breadcrumb?
    end

    test 'should not update qrcode param if module is disabled' do
      disable_optional_module @super_administrator, @qrcode_module, 'Qrcode' # in test_helper.rb
      sign_in @administrator
      patch :update, params: { id: @setting, setting: { show_qrcode: '1' } }
      assert_not assigns(:setting).show_qrcode?
    end

    test 'should not update picture_in_picture param if audio or video module is disabled' do
      assert @setting.picture_in_picture?
      disable_optional_module @super_administrator, @audio_module, 'Audio' # in test_helper.rb
      disable_optional_module @super_administrator, @video_module, 'Video' # in test_helper.rb
      sign_in @administrator
      patch :update, params: { id: @setting, setting: { picture_in_picture: '0' } }
      assert assigns(:setting).picture_in_picture?
    end

    #
    # Abilities
    # ============
    test 'should test abilities for subscriber' do
      sign_in @subscriber
      ability = Ability.new(@subscriber)
      assert ability.cannot?(:create, Setting.new), 'should not be able to create'
      assert ability.cannot?(:read, @setting), 'should not be able to read'
      assert ability.cannot?(:update, @setting), 'should not be able to update'
      assert ability.cannot?(:destroy, @setting), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, Setting.new), 'should not be able to create'
      assert ability.can?(:read, @setting), 'should be able to read'
      assert ability.can?(:update, @setting), 'should be able to update'
      assert ability.cannot?(:destroy, @setting), 'should not be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, Setting.new), 'should be able to create'
      assert ability.can?(:read, @setting), 'should be able to read'
      assert ability.can?(:update, @setting), 'should be able to update'
      assert ability.can?(:destroy, @setting), 'should be able to destroy'
    end

    #
    # Crud actions
    # ===============
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@setting, new_user_session_path, model_name, no_delete: true)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@setting, admin_dashboard_path, model_name, no_delete: true)
    end

    private

    def initialize_test
      @setting = settings(:one)

      @social_module = optional_modules(:social)
      @guest_book_module = optional_modules(:guest_book)
      @comment_module = optional_modules(:comment)
      @breadcrumb_module = optional_modules(:breadcrumb)
      @qrcode_module = optional_modules(:qrcode)
      @audio_module = optional_modules(:audio)
      @video_module = optional_modules(:video)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
