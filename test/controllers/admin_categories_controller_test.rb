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
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should get show page if logged in' do
      get :show, id: @category
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @category
      assert_response :success
    end

    test 'should update category if logged in' do
      patch :update, id: @category, category: { menu_id: @category.menu_id }
      assert_redirected_to admin_category_path(@category)
      assert flash[:notice].blank?
    end

    #
    # == Flash content
    #
    test 'should return correct flash content after updating a video' do
      video = fixture_file_upload 'videos/test.mp4', 'video/mp4'
      patch :update, id: @category, category: { video_upload_attributes: { video_file: video } }
      assert_equal I18n.t('video_upload.flash.upload_in_progress'), flash[:notice]
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

    test 'should not delete optional_modules params if administrator' do
      patch :update, id: @category_search, category: { optional: false, optional_module_id: @category_blog.id }
      assert assigns(:category).optional
      assert_equal @category_search.id, assigns(:category).optional_module_id
    end

    test 'should not update optional_modules params if administrator' do
      sign_in @super_administrator
      patch :update, id: @category_search, category: { optional: false, optional_module_id: @category_blog.id }
      assert_not assigns(:category).optional
      assert_equal @category_blog.id, assigns(:category).optional_module_id
    end

    #
    # == Menu
    #
    test 'should not update menu param if administrator' do
      patch :update, id: @category, category: { menu_id: 8 }
      assert_equal @category.menu_id, assigns(:category).menu_id
    end

    # test 'should not update menu param if menu_id is not present' do
    #   patch :update, id: @category, category: { menu_id: nil }
    #   assert_not assigns(:category).valid?
    # end

    #
    # == Backgrounds
    #
    test 'should have a background associated' do
      assert_not_nil @category.background
    end

    test 'should not have a background associated' do
      assert_nil @category_about.background
    end

    test 'should destroy background linked to category if SA' do
      sign_in @super_administrator
      assert_difference ['Category.count', 'Background.count'], -1 do
        delete :destroy, id: @category
      end
      assert_redirected_to admin_categories_path
    end

    test 'should destroy background if check_box is checked' do
      assert_not_nil @category.background
      patch :update, id: @category, category: { background_attributes: { _destroy: true } }
      assert_equal 'Pas de Background associé', assigns(:category).background_deco
    end

    test 'should remove background parameter if module is disabled' do
      disable_optional_module @super_administrator, @background_module, 'Background' # in test_helper.rb
      sign_in @administrator
      attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
      patch :update, id: @category, category: { background_attributes: { image: attachment } }
      assert_equal 'background-homepage.jpg', assigns(:category).background.image_file_name
    end

    test 'should not destroy background if module is disabled' do
      disable_optional_module @super_administrator, @background_module, 'Background' # in test_helper.rb
      sign_in @administrator
      patch :update, id: @category, category: { background_attributes: { _destroy: true } }
      assert_equal 'background-homepage.jpg', assigns(:category).background.image_file_name
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
      assert ability.cannot?(:create, Category.new), 'should not be able to create'
      assert ability.cannot?(:read, @category), 'should not be able to read'
      assert ability.cannot?(:update, @category), 'should not be able to update'
      assert ability.cannot?(:destroy, @category), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, Category.new), 'should not be able to create'
      assert ability.can?(:read, @category), 'should be able to read'
      assert ability.can?(:update, @category), 'should be able to update'
      assert ability.cannot?(:destroy, @category), 'should not be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, Category.new), 'should be able to create'
      assert ability.can?(:read, @category), 'should be able to read'
      assert ability.can?(:update, @category), 'should be able to update'
      assert ability.can?(:destroy, @category), 'should be able to destroy'
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@category, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@category, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @setting = settings(:one)
      @category = categories(:home)
      @category_about = categories(:about)
      @category_search = categories(:search)
      @category_blog = categories(:blog)
      @background_module = optional_modules(:background)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
