# frozen_string_literal: true
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
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should get show page if logged in' do
      get :show, id: @menu
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @menu
      assert_response :success
    end

    test 'should update menu if logged in' do
      patch :update, id: @menu, menu: {}
      assert_redirected_to admin_menu_path(@menu)
    end

    #
    # == Batch actions
    #
    test 'should return correct value for toggle_online batch action' do
      post :batch_action, batch_action: 'toggle_online', collection_selection: [@menu.id]
      [@menu].each(&:reload)
      assert_not @menu.online?
    end

    test 'should redirect to back and have correct flash notice for toggle_online batch action' do
      post :batch_action, batch_action: 'toggle_online', collection_selection: [@menu.id]
      assert_redirected_to admin_menus_path
      assert_equal I18n.t('active_admin.batch_actions.flash'), flash[:notice]
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

    test 'should delete menu if super_administrator' do
      sign_in @super_administrator
      @page = @menu_blog.page
      assert_difference ['Menu.count'], -1 do
        delete :destroy, id: @menu_blog
      end
      assert_redirected_to admin_menus_path
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
      assert ability.cannot?(:create, Menu.new), 'should not be able to create'
      assert ability.cannot?(:read, @menu), 'should not be able to read'
      assert ability.cannot?(:update, @menu), 'should not be able to update'
      assert ability.cannot?(:destroy, @menu), 'should not be able to destroy'

      assert ability.cannot?(:toggle_online, @menu), 'should not be able to toggle_online'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, Menu.new), 'should not be able to create'
      assert ability.can?(:read, @menu), 'should be able to read'
      assert ability.can?(:update, @menu), 'should be able to update'
      assert ability.cannot?(:destroy, @menu), 'should not be able to destroy'

      assert ability.can?(:toggle_online, @menu), 'should be able to toggle_online'

      # OptionalModule disabled
      disable_optional_module @super_administrator, @guest_book_module, 'GuestBook' # in test_helper.rb
      assert ability.cannot?(:read, @menu_guest_book), 'should not be able to read'
      assert ability.cannot?(:update, @menu_guest_book), 'should not be able to update'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, Menu.new), 'should be able to create'
      assert ability.can?(:read, @menu), 'should be able to read'
      assert ability.can?(:update, @menu), 'should be able to update'
      assert ability.can?(:destroy, @menu), 'should be able to destroy'

      assert ability.can?(:toggle_online, @menu), 'should be able to toggle_online'
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@menu, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@menu, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @setting = settings(:one)
      @request.env['HTTP_REFERER'] = admin_menus_path

      @menu = menus(:home)
      @menu_guest_book = menus(:guest_book)
      @menu_blog = menus(:blog)
      @guest_book_module = optional_modules(:guest_book)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
