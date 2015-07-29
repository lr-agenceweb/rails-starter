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
    # == Routes / Templates / Responses
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@background, new_user_session_path)
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
    test 'should redirect to dashboard page if trying to access background as subscriber' do
      sign_in @subscriber
      assert_crud_actions(@background, admin_dashboard_path)
    end

    #
    # == Abilities
    #
    test 'should test abilities for subscriber' do
      sign_in @subscriber
      ability = Ability.new(@subscriber)
      assert ability.cannot?(:create, Background.new), 'should not be able to create'
      assert ability.cannot?(:read, @background), 'should not be able to read'
      assert ability.cannot?(:update, @background), 'should not be able to update'
      assert ability.cannot?(:destroy, @background), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, Background.new), 'should not be able to create'
      assert ability.can?(:read, @background), 'should be able to read'
      assert ability.can?(:update, @background), 'should be able to update'
      assert ability.can?(:destroy, @background), 'should be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, Background.new), 'should be able to create'
      assert ability.can?(:read, @background), 'should be able to read'
      assert ability.can?(:update, @background), 'should be able to update'
      assert ability.can?(:destroy, @background), 'should be able to destroy'
    end

    #
    # == Background
    #
    test 'should update background if new picture is sent' do
      attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
      patch :update, id: @background, background: { image: attachment }
      background = assigns(:background)
      assert_equal background.image_file_name, 'background-paris.jpg'
      assert_equal background.image_content_type, 'image/jpeg'
      delete :destroy, id: background.id
    end

    test 'should destroy all attachments when destroying background' do
      attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
      patch :update, id: @background, background: { image: attachment }

      background = assigns(:background)
      existing_styles = []
      background.image.styles.keys.collect do |style|
        f = background.image.path(style)
        assert File.exist?(f), "File #{f} should exist"
        existing_styles << f
      end

      delete :destroy, id: background.id
      existing_styles.each do |f|
        assert_not File.exist?(f), "File #{f} should not exist"
      end
    end

    private

    def initialize_test
      @category = categories(:home)
      @category_about = categories(:about)
      @background = backgrounds(:contact)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
