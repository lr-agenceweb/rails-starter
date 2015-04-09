require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == CategoriesController test
  #
  class CategoriesControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    test 'should redirect to users/sign_in if not logged in' do
      sign_out @anthony
      get :index
      assert_redirected_to new_user_session_path
      get :show, id: @category.id
      assert_redirected_to new_user_session_path
      get :edit, id: @category.id
      assert_redirected_to new_user_session_path
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should show show page if logged in' do
      get :show, id: @category.id
      assert_response :success
    end

    test 'should show edit page if logged in' do
      get :edit, id: @category.id
      assert_response :success
    end

    test 'should update category if logged in' do
      patch :update, id: @category.id, category: {}
      assert_redirected_to admin_category_path(@category)
    end

    private

    def initialize_test
      @category = categories(:home)
      @anthony = users(:anthony)
      sign_in @anthony
    end
  end
end
