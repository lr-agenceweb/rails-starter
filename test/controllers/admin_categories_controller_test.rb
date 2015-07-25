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
      sign_out @administrator
      get :index
      assert_redirected_to new_user_session_path
      get :show, id: @category
      assert_redirected_to new_user_session_path
      get :edit, id: @category
      assert_redirected_to new_user_session_path
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should show show page if logged in' do
      get :show, id: @category
      assert_response :success
    end

    test 'should show edit page if logged in' do
      get :edit, id: @category
      assert_response :success
    end

    test 'should update category if logged in' do
      patch :update, id: @category, category: {}
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
        delete :destroy, id: @category
      end
      assert_not_nil @category.background
      assert_redirected_to admin_dashboard_path
    end

    test 'should delete optional_modules params if administrator' do
      patch :update, id: @category_search, category: { optional: false, optional_module_id: @category_blog.id }
      assert assigns(:category).optional
      assert_equal @category_search.id, assigns(:category).optional_module_id
    end

    test 'should update optional_modules params if administrator' do
      sign_in @super_administrator
      patch :update, id: @category_search, category: { optional: false, optional_module_id: @category_blog.id }
      assert_not assigns(:category).optional
      assert_equal @category_blog.id, assigns(:category).optional_module_id
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
      sign_in @super_administrator
      assert_difference ['Category.count', 'Background.count'], -1 do
        delete :destroy, id: @category
      end
      assert_redirected_to admin_categories_path
    end

    test 'should destroy background if check_box is checked' do
      assert_not_nil @category.background
      patch :update, id: @category, category: { background: { _destroy: true } }
      assert_equal 'Pas de Background associé', assigns(:category).background
    end

    #
    # == Color
    #
    test 'should remove color if checkbox is not checked' do
      assert_equal '#F0F', @category.color
      patch :update, id: @category, category: { custom_background_color: '0' }
      assert_nil assigns(:category).color
    end

    test 'should keep color if checkbox is checked' do
      patch :update, id: @category, category: { custom_background_color: '1' }
      assert_equal '#F0F', assigns(:category).color
    end

    #
    # == Destroy
    #
    test 'should destroy slider' do
      sign_in @super_administrator
      assert_difference ['Slider.count'], -1 do
        delete :destroy, id: @category
      end
      assert_redirected_to admin_categories_path
    end

    private

    def initialize_test
      @category = categories(:home)
      @category_about = categories(:about)
      @category_search = categories(:search)
      @category_blog = categories(:blog)

      @super_administrator = users(:anthony)
      @administrator = users(:bob)
      sign_in @administrator
    end
  end
end
