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
      sign_out @bob
      get :index
      assert_redirected_to new_user_session_path
      get :show, id: @optional_module
      assert_redirected_to new_user_session_path
      get :edit, id: @optional_module
      assert_redirected_to new_user_session_path
    end

    test 'should redirect to dashboard if user is administrator' do
      get :index
      assert_redirected_to admin_dashboard_path
      get :show, id: @optional_module
      assert_redirected_to admin_dashboard_path
      get :edit, id: @optional_module
      assert_redirected_to admin_dashboard_path
      delete :destroy, id: @optional_module
      assert_redirected_to admin_dashboard_path
    end

    test 'should redirect to dashboard if user is subscriber' do
      sign_in @alice
      get :index
      assert_redirected_to admin_dashboard_path
      get :show, id: @optional_module
      assert_redirected_to admin_dashboard_path
      get :edit, id: @optional_module
      assert_redirected_to admin_dashboard_path
      get :destroy, id: @optional_module
      assert_redirected_to admin_dashboard_path
    end

    test 'should be all good if user is super_administrator' do
      sign_in @anthony
      get :index
      assert :success
      get :show, id: @optional_module
      assert :success
      get :edit, id: @optional_module
      assert :success
      delete :destroy, id: @optional_module
      assert :success
    end

    private

    def initialize_test
      @anthony = users(:anthony)
      @bob = users(:bob)
      @alice = users(:alice)
      @optional_module = optional_modules(:guest_book)
      sign_in @bob
    end
  end
end
