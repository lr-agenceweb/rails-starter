require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == BackgroundsController test
  #
  class BackgroundsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Routing
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @bob
      get :index
      assert_redirected_to new_user_session_path
      get :show, id: @background
      assert_redirected_to new_user_session_path
      get :edit, id: @background
      assert_redirected_to new_user_session_path
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should visit show page if logged in' do
      get :show, id: @background
      assert_response :success
    end

    test 'should show edit page if logged in' do
      get :edit, id: @background
      assert_response :success
    end

    test 'should update category if logged in' do
      patch :update, id: @background, background: {}
      assert_redirected_to admin_background_path(@background)
    end

    test 'should destroy background' do
      assert_difference 'Background.count', -1 do
        delete :destroy, id: @background
      end
      assert_redirected_to admin_backgrounds_path
    end

    #
    # == User role
    #
    test 'should not access new page if administrator' do
      get :new
      assert_redirected_to admin_dashboard_path
    end

    #
    # == Background
    #
    # # TODO: Fix this broken test
    # test 'should update background if new picture is sent' do
    #   attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
    #   patch :update, id: @background, background: { image: attachment }
    #   assert_equal assigns(:background).image_file_name, 'background-paris.jpg'
    #   assert_equal assigns(:background).image_content_type, 'image/jpeg'
    # end

    # # TODO: Fix this broken test
    # test 'should destroy all attachments when destroying background' do
    #   attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
    #   patch :update, id: @background, background: { image: attachment }

    #   background = assigns(:background)
    #   existing_styles = background.image.styles.keys.collect do |style|
    #     background.image.path(style)
    #   end
    #   delete :destroy, id: background.id
    #   existing_styles.each { |f| assert_not File.exist?(f) }
    # end

    private

    def initialize_test
      @category = categories(:home)
      @category_about = categories(:about)
      @background = backgrounds(:contact)
      @anthony = users(:anthony)
      @bob = users(:bob)
      sign_in @bob
    end
  end
end
