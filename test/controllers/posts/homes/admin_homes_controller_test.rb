require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == HomesController test
  #
  class HomesControllerTest < ActionController::TestCase
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
      get :show, id: @home
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @home
      assert_response :success
    end

    test 'should update home if logged in' do
      patch :update, id: @home, home: {}
      assert_redirected_to admin_home_path(@home)
    end

    test 'should destroy home' do
      assert_difference ['Home.count', 'Referencement.count'], -1 do
        delete :destroy, id: @home
      end
      assert_redirected_to admin_homes_path
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
      assert ability.cannot?(:create, Home.new), 'should not be able to create'
      assert ability.cannot?(:read, @home), 'should not be able to read'
      assert ability.cannot?(:update, @home), 'should not be able to update'
      assert ability.cannot?(:destroy, @home), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.can?(:create, Blog.new), 'should be able to create'
      assert ability.can?(:read, @home), 'should be able to read'
      assert ability.can?(:update, @home), 'should be able to update'
      assert ability.can?(:destroy, @home), 'should be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, Blog.new), 'should be able to create'
      assert ability.can?(:read, @home), 'should be able to read'
      assert ability.can?(:update, @home), 'should be able to update'
      assert ability.can?(:destroy, @home), 'should be able to destroy'
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@home, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@home, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @home = posts(:home)
      @setting = settings(:one)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
