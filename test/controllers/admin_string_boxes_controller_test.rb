# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == StringBoxesController test
  #
  class StringBoxesControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should get show page if logged in' do
      get :show, id: @string_box
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @string_box
      assert_response :success
    end

    test 'should update category if logged in' do
      patch :update, id: @string_box, string_box: {}
      assert_redirected_to admin_string_box_path(@string_box)
    end

    test 'should not destroy string_box' do
      assert_no_difference 'StringBox.count' do
        delete :destroy, id: @string_box
      end
      assert_redirected_to admin_dashboard_path
    end

    #
    # == Crud actions
    #
    test 'should be able to access new page if super administrator' do
      sign_in @super_administrator
      get :new
      assert_response :success
    end

    test 'should be able to create if super administrator' do
      sign_in @super_administrator
      assert_difference 'StringBox.count' do
        post :create, string_box: {}
      end
      assert_redirected_to admin_string_box_path(assigns(:string_box))
    end

    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@string_box, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@string_box, admin_dashboard_path, model_name)
    end

    #
    # == User roles
    #
    test 'should not save optional_module params if administrator' do
      patch :update, id: @string_box, string_box: { optional_module_id: @adult_module.id }
      assert_nil assigns(:string_box).optional_module_id
    end

    test 'should save optional_module params if super_administrator' do
      sign_in @super_administrator
      patch :update, id: @string_box, string_box: { optional_module_id: @adult_module.id }
      assert_equal @adult_module.id, assigns(:string_box).optional_module_id
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
      assert ability.cannot?(:create, StringBox.new), 'should not be able to create'
      assert ability.cannot?(:read, @string_box), 'should not be able to read'
      assert ability.cannot?(:update, @string_box), 'should not be able to update'
      assert ability.cannot?(:destroy, @string_box), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, StringBox.new), 'should not be able to create'
      assert ability.can?(:read, @string_box), 'should be able to read'
      assert ability.can?(:update, @string_box), 'should be able to update'
      assert ability.cannot?(:destroy, @string_box), 'should not be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, StringBox.new), 'should be able to create'
      assert ability.can?(:read, @string_box), 'should be able to read'
      assert ability.can?(:update, @string_box), 'should be able to update'
      assert ability.can?(:destroy, @string_box), 'should be able to destroy'
    end

    private

    def initialize_test
      @setting = settings(:one)
      @string_box = string_boxes(:error_404)
      @string_box_newsletter = string_boxes(:welcome_newsletter)
      @string_box_adult = string_boxes(:adult_not_validated_popup_content)
      @newsletter_module = optional_modules(:newsletter)
      @adult_module = optional_modules(:adult)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
