# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == PagesController test
  #
  class PagesControllerTest < ActionController::TestCase
    include Devise::Test::ControllerHelpers
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
      get :show, id: @page
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @page
      assert_response :success
    end

    test 'should update page if logged in' do
      patch :update, id: @page, page: { menu_id: @page.menu_id }
      assert_redirected_to admin_page_path(@page)
      assert flash[:notice].blank?
    end

    #
    # == Batch actions
    #
    test 'should redirect to back and have correct flash notice for reset_cache batch action' do
      post :batch_action, batch_action: 'reset_cache', collection_selection: [@page.id]
      assert_redirected_to admin_pages_path
      assert_equal I18n.t('active_admin.batch_actions.reset_cache'), flash[:notice]
    end

    #
    # == Flash content
    #
    test 'should return correct flash content after updating a video' do
      video = fixture_file_upload 'videos/test.mp4', 'video/mp4'
      patch :update, id: @page, page: { video_upload_attributes: { video_file: video } }
      assert assigns(:page).video_upload.video_file_processing?, 'should be processing video task'
      assert_equal [I18n.t('video_upload.flash.upload_in_progress')], flash[:notice]
    end

    #
    # == User role
    #
    test 'should not create page if administrator' do
      assert_no_difference ['Page.count'] do
        post :create, page: {}
      end
      assert_redirected_to admin_dashboard_path
    end

    test 'should not delete page if administrator' do
      assert_no_difference ['Page.count'] do
        delete :destroy, id: @page
      end
      assert_not_nil @page.background
      assert_redirected_to admin_dashboard_path
    end

    test 'should not delete optional_modules params if administrator' do
      patch :update, id: @page_search, page: { optional: false, optional_module_id: @page_blog.id }
      assert assigns(:page).optional
      assert_equal @page_search.id, assigns(:page).optional_module_id
    end

    test 'should not update optional_modules params if administrator' do
      sign_in @super_administrator
      patch :update, id: @page_search, page: { optional: false, optional_module_id: @page_blog.id }
      assert_not assigns(:page).optional
      assert_equal @page_blog.id, assigns(:page).optional_module_id
    end

    #
    # == Menu
    #
    test 'should not update menu param if administrator' do
      patch :update, id: @page, page: { menu_id: 8 }
      assert_equal @page.menu_id, assigns(:page).menu_id
    end

    # test 'should not update menu param if menu_id is not present' do
    #   patch :update, id: @page, page: { menu_id: nil }
    #   assert_not assigns(:page).valid?
    # end

    #
    # == Backgrounds
    #
    test 'should have a background associated' do
      assert_not_nil @page.background
    end

    test 'should not have a background associated' do
      assert_nil @page_about.background
    end

    test 'should destroy background linked to page if SA' do
      sign_in @super_administrator
      assert_difference ['Page.count', 'Background.count'], -1 do
        delete :destroy, id: @page
      end
      assert_redirected_to admin_pages_path
    end

    test 'should remove background parameter if module is disabled' do
      disable_optional_module @super_administrator, @background_module, 'Background' # in test_helper.rb
      sign_in @administrator
      attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
      patch :update, id: @page, page: { background_attributes: { image: attachment } }
      assert_equal 'background-homepage.jpg', assigns(:page).background.image_file_name
    end

    test 'should not destroy background if module is disabled' do
      disable_optional_module @super_administrator, @background_module, 'Background' # in test_helper.rb
      sign_in @administrator
      patch :update, id: @page, page: { background_attributes: { _destroy: true } }
      assert_equal 'background-homepage.jpg', assigns(:page).background.image_file_name
    end

    #
    # == Color
    #
    test 'should update color' do
      patch :update, id: @page, page: { color: '#F0F' }
      assert_equal '#F0F', assigns(:page).color
    end

    #
    # == Destroy
    #
    test 'should destroy slider' do
      sign_in @super_administrator
      assert_difference ['Slider.count'], -1 do
        delete :destroy, id: @page
      end
      assert_redirected_to admin_pages_path
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
      assert ability.cannot?(:create, Page.new), 'should not be able to create'
      assert ability.cannot?(:read, @page), 'should not be able to read'
      assert ability.cannot?(:update, @page), 'should not be able to update'
      assert ability.cannot?(:destroy, @page), 'should not be able to destroy'

      assert ability.cannot?(:reset_cache, @page), 'should be able to reset_cache'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, Page.new), 'should not be able to create'
      assert ability.can?(:read, @page), 'should be able to read'
      assert ability.can?(:update, @page), 'should be able to update'
      assert ability.cannot?(:destroy, @page), 'should not be able to destroy'

      assert ability.can?(:reset_cache, @page), 'should be able to reset_cache'

      # OptionalModule disabled
      disable_optional_module @super_administrator, @guest_book_module, 'GuestBook' # in test_helper.rb
      assert ability.cannot?(:read, @page_guest_book), 'should not be able to read'
      assert ability.cannot?(:update, @page_guest_book), 'should not be able to update'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, Page.new), 'should be able to create'
      assert ability.can?(:read, @page), 'should be able to read'
      assert ability.can?(:update, @page), 'should be able to update'
      assert ability.can?(:destroy, @page), 'should be able to destroy'

      assert ability.can?(:reset_cache, @page), 'should be able to reset_cache'
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@page, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@page, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @setting = settings(:one)
      @request.env['HTTP_REFERER'] = admin_pages_path

      @page = pages(:home)
      @page_about = pages(:about)
      @page_search = pages(:search)
      @page_blog = pages(:blog)
      @page_guest_book = pages(:guest_book)
      @background_module = optional_modules(:background)
      @guest_book_module = optional_modules(:guest_book)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
