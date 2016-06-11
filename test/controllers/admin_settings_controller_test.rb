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
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Routing
    #
    test 'should redirect index to show if logged in' do
      get :index
      assert_response 301
      assert_redirected_to admin_setting_path(@setting)
    end

    test 'should show show page if logged in' do
      get :show, id: @setting
      assert_response :success
    end

    test 'should show edit page if logged in' do
      get :edit, id: @setting
      assert_response :success
    end

    test 'should update setting if logged in' do
      patch :update, id: @setting, setting: {}
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
    # == Nested attributes
    #
    test 'should destroy location if destroy is check' do
      location_attrs = {
        id: @setting.location.id,
        _destroy: 'true'
      }
      assert @setting.location.present?
      assert_difference ['Location.count'], -1 do
        patch :update, id: @setting, setting: { location_attributes: location_attrs }
        assert assigns(:setting).valid?
        @setting.reload
        assigns(:setting).reload

        assert assigns(:setting).location.blank?
        assert @setting.location.blank?
      end
    end

    #
    # == Maintenance
    #
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
    # == Form validations
    #
    test 'should not update article without name' do
      patch :update, id: @setting
      assert_not @setting.update(name: nil)
    end

    test 'should not update article without title' do
      patch :update, id: @setting
      assert_not @setting.update(title: nil)
    end

    test 'should not update if postcode is not numeric' do
      patch :update, id: @setting, setting: { location_attributes: { postcode: 'bad_value' } }
      assert_not assigns(:setting).valid?
      assert assigns(:setting).errors.keys.include?('location.postcode'.to_sym)
    end

    test 'should not update social param if module is disabled' do
      disable_optional_module @super_administrator, @social_module, 'Social' # in test_helper.rb
      sign_in @administrator
      patch :update, id: @setting, setting: { show_social: '1' }
      assert_not assigns(:setting).show_social?
    end

    test 'should not update breadcrumb param if module is disabled' do
      disable_optional_module @super_administrator, @breadcrumb_module, 'Breadcrumb' # in test_helper.rb
      sign_in @administrator
      patch :update, id: @setting, setting: { show_breadcrumb: '1' }
      assert_not assigns(:setting).show_breadcrumb?
    end

    test 'should not update qrcode param if module is disabled' do
      disable_optional_module @super_administrator, @qrcode_module, 'Qrcode' # in test_helper.rb
      sign_in @administrator
      patch :update, id: @setting, setting: { show_qrcode: '1' }
      assert_not assigns(:setting).show_qrcode?
    end

    #
    # == Abilities
    #
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
    # == Crud actions
    #
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

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
