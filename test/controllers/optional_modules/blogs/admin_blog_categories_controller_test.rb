# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == BlogCategoriesController test
  #
  class BlogCategoriesControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should get show page if logged in' do
      get :show, id: @blog_category
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @blog_category
      assert_response :success
    end

    test 'should update blog_category if logged in' do
      patch :update, id: @blog_category, blog_category: {}
      assert_redirected_to admin_blog_category_path(@blog_category)
    end

    test 'should destroy blog category' do
      assert_difference 'BlogCategory.count', -1 do
        delete :destroy, id: @blog_category
      end
    end

    test 'should destroy blogs posts linked to category' do
      assert_difference 'Blog.count', -2 do
        delete :destroy, id: @blog_category
      end
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@blog_category, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@blog_category, admin_dashboard_path, model_name)
    end

    #
    # == Module disabled
    #
    test 'should not access page if blog module is disabled' do
      disable_optional_module @super_administrator, @blog_module, 'Blog' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@blog_category, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@blog_category, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@blog_category, admin_dashboard_path, model_name)
    end

    #
    # == Maintenance
    #
    test 'should not render maintenance even if enabled and SA' do
      sign_in @super_administrator
      assert_no_maintenance_backend(:show, @blog_category)
    end

    test 'should not render maintenance even if enabled and Admin' do
      sign_in @administrator
      assert_no_maintenance_backend(:show, @blog_category)
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
      assert ability.cannot?(:create, BlogCategory.new), 'should not be able to create'
      assert ability.cannot?(:read, @blog_category), 'should not be able to read'
      assert ability.cannot?(:update, @blog_category), 'should not be able to update'
      assert ability.cannot?(:destroy, @blog_category), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.can?(:create, BlogCategory.new), 'should be able to create'
      assert ability.can?(:read, @blog_category), 'should be able to read'
      assert ability.can?(:update, @blog_category), 'should be able to update'
      assert ability.can?(:destroy, @blog_category), 'should be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, BlogCategory.new), 'should be able to create'
      assert ability.can?(:read, @blog_category), 'should be able to read'
      assert ability.can?(:update, @blog_category), 'should be able to update'
      assert ability.can?(:destroy, @blog_category), 'should be able to destroy'
    end

    private

    def initialize_test
      @setting = settings(:one)
      @blog_category = blog_categories(:one)
      @blog_module = optional_modules(:blog)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
