require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == MenusController test
  #
  class MenusControllerTest < ActionController::TestCase
    include Devise::TestHelpers
    include ActionView::Helpers::AssetTagHelper

    setup :initialize_test

    #
    # == Routing
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@menu, new_user_session_path)
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should show show page if logged in' do
      get :show, id: @menu
      assert_response :success
    end

    test 'should show edit page if logged in' do
      get :edit, id: @menu
      assert_response :success
    end

    test 'should update menu if logged in' do
      patch :update, id: @menu, menu: {}
      assert_redirected_to admin_menu_path(@menu)
    end

    #
    # == User role
    #
    test 'should not create menu if administrator' do
      assert_no_difference ['Menu.count'] do
        post :create, menu: {}
      end
      assert_redirected_to admin_dashboard_path
    end

    test 'should not delete menu if administrator' do
      assert_no_difference ['Menu.count'] do
        delete :destroy, id: @menu
      end
      assert_redirected_to admin_dashboard_path
    end

    #
    # == Abilities
    #
    test 'should test abilities for subscriber' do
      sign_in @subscriber
      ability = Ability.new(@subscriber)
      assert ability.cannot?(:create, Menu.new), 'should not be able to create'
      assert ability.cannot?(:read, @menu), 'should not be able to read'
      assert ability.cannot?(:update, @menu), 'should not be able to update'
      assert ability.cannot?(:destroy, @menu), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, Menu.new), 'should not be able to create'
      assert ability.can?(:read, @menu), 'should be able to read'
      assert ability.can?(:update, @menu), 'should be able to update'
      assert ability.cannot?(:destroy, @menu), 'should not be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, Menu.new), 'should be able to create'
      assert ability.can?(:read, @menu), 'should be able to read'
      assert ability.can?(:update, @menu), 'should be able to update'
      assert ability.can?(:destroy, @menu), 'should be able to destroy'
    end

    #
    # == Subscriber
    #
    test 'should redirect to dashboard page if trying to access slider as subscriber' do
      sign_in @subscriber
      assert_crud_actions(@menu, admin_dashboard_path)
    end

    private

    def initialize_test
      @menu = menus(:home)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end

    def assert_crud_actions(obj, url)
      get :index
      assert_redirected_to url
      get :show, id: obj
      assert_redirected_to url
      get :edit, id: obj
      assert_redirected_to url
      post :create, menu: {}
      assert_redirected_to url
      patch :update, id: obj, menu: {}
      assert_redirected_to url
      delete :destroy, id: obj
      assert_redirected_to url
    end
  end
end
