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
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should get show page if logged in' do
      get :show, id: @slider
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @slider
      assert_response :success
    end

    test 'should update slider if logged in' do
      patch :update, id: @slider, slider: { time_to_show: 2000, cateogry: 5, animate: 'crossfade' }
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
      assert ability.cannot?(:create, Slider.new), 'should not be able to create'
      assert ability.cannot?(:read, Slider.new), 'should not be able to read'
      assert ability.cannot?(:update, Slider.new), 'should not be able to update'
      assert ability.cannot?(:destroy, Slider.new), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.can?(:create, Slider.new), 'should be able to create'
      assert ability.can?(:read, Slider.new), 'should be able to read'
      assert ability.can?(:update, Slider.new), 'should be able to update'
      assert ability.can?(:destroy, Slider.new), 'should be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, Slider.new), 'should be able to create'
      assert ability.can?(:read, Slider.new), 'should be able to read'
      assert ability.can?(:update, Slider.new), 'should be able to update'
      assert ability.can?(:destroy, Slider.new), 'should be able to destroy'
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@slider, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@slider, admin_dashboard_path, model_name)
    end

    #
    # == Module disabled
    #
    test 'should not access page if slider module is disabled' do
      disable_optional_module @super_administrator, @slider_module, 'Slider' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@slider, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@slider, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@slider, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @setting = settings(:one)
      @slider = sliders(:online)
      @slider_module = optional_modules(:slider)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
