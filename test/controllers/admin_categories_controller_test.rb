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
    include ActionView::Helpers::AssetTagHelper

    setup :initialize_test

    #
    # == Routing
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @bob
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

    #
    # == User role
    #
    test 'should not create category if administrator' do
      assert_no_difference ['Category.count'] do
        post :create, category: {}
      end
      assert_redirected_to admin_dashboard_path
    end

    test 'should not delete category if administrator' do
      assert_no_difference ['Category.count'] do
        delete :destroy, id: @category.id
      end
      assert_not_nil @category.background
      assert_redirected_to admin_dashboard_path
    end

    #
    # == Backgrounds
    #
    test 'should have a background associated' do
      assert_not_nil @category.background
    end

    test 'should not have a background associated' do
      assert_nil @category_about.background
    end

    test 'should destroy background linked to category if super_administrator' do
      sign_in @anthony
      assert_difference ['Category.count', 'Background.count'], -1 do
        delete :destroy, id: @category.id
      end
      assert_nil @category.background
      assert_redirected_to admin_categories_path
    end

    test 'should destroy background if check_box is checked' do
      assert_not_nil @category.background
      patch :update, id: @category.id, category: { background: { _destroy: true } }
      assert_equal assigns(:category).background, image_tag('/system/default/small-missing.png')
    end

    private

    def initialize_test
      @category = categories(:home)
      @category_about = categories(:about)
      @anthony = users(:anthony)
      @bob = users(:bob)
      sign_in @bob
    end
  end
end
