require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == DashboardController test
  #
  class DashboardControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    test 'should redirect to users/sign_in if not logged in' do
      get :index
      assert_redirected_to new_user_session_path
    end

    test 'should show dashboard page if logged in' do
      sign_in @administrator
      get :index
      assert_response :success
    end

    test 'should redirect to users/sign_in after logged out' do
      sign_in @administrator
      sign_out @administrator
      get :index
      assert_redirected_to new_user_session_path
    end

    test 'should user email be the bob@test.fr for administrator' do
      sign_in @administrator
      get :index
      assert_equal(@administrator.email, 'bob@test.fr')
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
      assert_response :success
    end

    test 'should redirect to login if maintenance and not connected' do
      sign_out @administrator
      assert_maintenance_backend
      assert_redirected_to new_user_session_path
    end

    private

    def initialize_test
      @setting = settings(:one)
      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
    end
  end
end
