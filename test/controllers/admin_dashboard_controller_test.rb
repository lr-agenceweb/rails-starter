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
      sign_in @anthony
      get :index
      assert_response :success
    end

    test 'should redirect to users/sign_in after logged out' do
      sign_in @anthony
      sign_out @anthony
      get :index
      assert_redirected_to new_user_session_path
    end

    test 'should user email be the anthony@test.fr for anthony' do
      sign_in @anthony
      get :index
      assert_equal(@anthony.email, 'anthony@test.fr')
    end

    private

    def initialize_test
      @anthony = users(:anthony)
    end
  end
end
