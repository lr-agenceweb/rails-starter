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
    test 'should redirect to show page if logged in' do
      get :index
      assert_redirected_to admin_plan_path(@map)
    end

    test 'should get show page if logged in' do
      get :show, id: @map
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @map
      assert_response :success
    end

    test 'should update slider if logged in' do
      patch :update, id: @map
      assert_redirected_to admin_plan_path(assigns(:map))
    end

    #
    # == Validation
    #
    test 'should not update if marker_icon is not allowed' do
      patch :update, id: @map, map: { marker_icon: 'bad_value' }
      assert_not assigns(:plan).valid?
    end

    test 'should not update if postcode is not an integer' do
      patch :update, id: @map, map: { location_attributes: { postcode: 'bad_value' } }
      assert_not assigns(:plan).valid?
    end

    #
    # == Abilities
    #
    test 'should test abilities for subscriber' do
      sign_in @subscriber
      ability = Ability.new(@subscriber)
      assert ability.cannot?(:create, Map.new), 'should not be able to create'
      assert ability.cannot?(:read, @map), 'should not be able to read'
      assert ability.cannot?(:update, @map), 'should not be able to update'
      assert ability.cannot?(:destroy, @map), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, Map.new), 'should not be able to create'
      assert ability.can?(:read, @map), 'should be able to read'
      assert ability.can?(:update, @map), 'should be able to update'
      assert ability.cannot?(:destroy, @map), 'should not be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, Map.new), 'should not be able to create'
      assert ability.can?(:read, @map), 'should be able to read'
      assert ability.can?(:update, @map), 'should be able to update'
      assert ability.cannot?(:destroy, @map), 'should not be able to destroy'
    end

    #
    # == Destroy
    #
    test 'should not destroy map' do
      assert_no_difference ['Map.count', 'Location.count'] do
        delete :destroy, id: @map
      end
      assert_redirected_to admin_dashboard_path
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@map, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@map, admin_dashboard_path, model_name)
    end

    #
    # == Module disabled
    #
    test 'should not access page if map module is disabled' do
      disable_optional_module @super_administrator, @map_module, 'Map' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@map, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@map, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@map, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @map = maps(:one)
      @map_module = optional_modules(:map)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
