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

    private

    def initialize_test
      @administrator = users(:bob)
    end
  end
end
