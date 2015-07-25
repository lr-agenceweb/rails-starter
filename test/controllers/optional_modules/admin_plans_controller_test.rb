require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == MapsController test
  #
  class PlansControllerTest < ActionController::TestCase
    include Devise::TestHelpers
    include Rails.application.routes.url_helpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      get :index
      assert_redirected_to new_user_session_path
      get :show, id: @map
      assert_redirected_to new_user_session_path
      patch :update, id: @map
      assert_redirected_to new_user_session_path
      delete :destroy, id: @map
      assert_redirected_to new_user_session_path
    end

    test 'should redirect to show page if logged in' do
      get :index
      assert_redirected_to admin_plan_path(@map)
    end

    test 'should access show page if logged in' do
      get :show, id: @map
      assert_response :success
    end

    test 'should access edit page if logged in' do
      get :edit, id: @map
      assert_response :success
    end

    test 'should update slider if logged in' do
      patch :update, id: @map
      assert_redirected_to admin_plan_path(assigns(:map))
    end

    #
    # == Destroy
    #
    test 'should not destroy map' do
      assert_no_difference ['Map.count'] do
        delete :destroy, id: @map
      end
      assert_redirected_to admin_dashboard_path
    end

    #
    # == Module disabled
    #
    test 'should not access page if map module is disabled' do
      disable_optional_module @super_administrator, @map_module, 'Map' # in test_helper.rb
      sign_in @administrator
      get :index
      assert_redirected_to admin_dashboard_path
    end

    private

    def initialize_test
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      @map = maps(:one)
      @map_module = optional_modules(:map)

      sign_in @administrator
    end
  end
end