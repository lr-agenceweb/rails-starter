# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == OptionalModulesController test
  #
  class OptionalModulesControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == User role
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@optional_module, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if user is subscriber' do
      sign_in @subscriber
      assert_crud_actions(@optional_module, admin_dashboard_path, model_name)
    end

    test 'should redirect to dashboard if user is administrator' do
      assert_crud_actions(@optional_module, admin_dashboard_path, model_name)
    end

    test 'should be all good if user is super_administrator' do
      sign_in @super_administrator
      get :index
      assert :success
      get :show, id: @optional_module
      assert :success
      get :edit, id: @optional_module
      assert :success
      post :create, optional_module: {}
      assert :success
      patch :update, id: @optional_module, optional_module: {}
      assert :success
      delete :destroy, id: @optional_module
      assert :success
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
      get :index
      assert_redirected_to admin_dashboard_path
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
      assert ability.cannot?(:create, OptionalModule.new), 'should not be able to create'
      assert ability.cannot?(:read, OptionalModule.new), 'should not be able to read'
      assert ability.cannot?(:update, OptionalModule.new), 'should not be able to update'
      assert ability.cannot?(:destroy, OptionalModule.new), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, OptionalModule.new), 'should not be able to create'
      assert ability.cannot?(:read, OptionalModule.new), 'should not be able to read'
      assert ability.cannot?(:update, OptionalModule.new), 'should not be able to update'
      assert ability.cannot?(:destroy, OptionalModule.new), 'should not be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, OptionalModule.new), 'should be able to create'
      assert ability.can?(:read, OptionalModule.new), 'should be able to read'
      assert ability.can?(:update, OptionalModule.new), 'should be able to update'
      assert ability.can?(:destroy, OptionalModule.new), 'should be able to destroy'
    end

    private

    def initialize_test
      @setting = settings(:one)
      @optional_module = optional_modules(:guest_book)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
