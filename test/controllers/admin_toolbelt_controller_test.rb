# frozen_string_literal: true
require 'test_helper'

#
# Admin namespace
# ==================
module Admin
  #
  # ToolbeltController test
  # =========================
  class ToolbeltControllerTest < ActionController::TestCase
    include Devise::Test::ControllerHelpers

    setup :initialize_test

    #
    # Routes / Templates / Responses
    # ================================
    test 'should get index page if logged in as super_administrator' do
      sign_in @super_administrator
      get :index
      assert_response :success
    end

    test 'should redirect to dashboard if logged in as administrator' do
      get :index
      assert_redirected_to admin_dashboard_path
    end

    test 'should redirect to dashboard if logged in as subscriber' do
      sign_in @subscriber
      get :index
      assert_redirected_to admin_dashboard_path
    end

    test 'should redirect to login page if not connected' do
      sign_out @administrator
      get :index
      assert_redirected_to new_user_session_path
    end

    #
    # Maintenance
    # =============
    test 'should not render maintenance even if enabled and SA' do
      sign_in @super_administrator
      assert_no_maintenance_backend
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
      sign_in @administrator
    end
  end
end
