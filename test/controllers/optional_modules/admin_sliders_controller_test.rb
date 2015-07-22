require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == SlidersController test
  #
  class SlidersControllerTest < ActionController::TestCase
    include Devise::TestHelpers
    include Rails.application.routes.url_helpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      get :index, id: @slider
      assert_redirected_to new_user_session_path
      get :show, id: @slider
      assert_redirected_to new_user_session_path
      patch :update, id: @slider
      assert_redirected_to new_user_session_path
      delete :destroy, id: @slider
      assert_redirected_to new_user_session_path
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should access show page if logged in' do
      get :show, id: @slider
      assert_response :success
    end

    test 'should access edit page if logged in' do
      get :edit, id: @slider
      assert_response :success
    end

    test 'should update slider if logged in' do
      patch :update, id: @slider
      assert_redirected_to admin_slider_path(assigns(:slider))
    end

    #
    # == Destroy
    #
    test 'should destroy slider' do
      assert_difference ['Slider.count'], -1 do
        delete :destroy, id: @slider
      end
      assert_redirected_to admin_sliders_path
    end

    test 'should destroy slides with slider' do
      assert_difference ['Slide.count'], -3 do
        delete :destroy, id: @slider
      end
      assert_redirected_to admin_sliders_path
    end

    #
    # == Module disabled
    #
    test 'should not access page if slider module is disabled' do
      disable_optional_module @super_administrator, @slider_module, 'Slider' # in test_helper.rb
      sign_in @administrator
      get :index
      assert_redirected_to admin_dashboard_path
    end

    private

    def initialize_test
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      @slider = sliders(:online)
      @slider_module = optional_modules(:slider)

      sign_in @administrator
    end
  end
end