# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == PicturesController test
  #
  class PicturesControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should visit show page if logged in' do
      get :show, id: @picture
      assert_response :success
    end

    test 'should show edit page if logged in' do
      get :edit, id: @picture
      assert_response :success
    end

    test 'should update category if logged in' do
      patch :update, id: @picture, picture: {}
      assert_redirected_to admin_picture_path(@picture)
    end

    test 'should destroy picture' do
      assert_difference 'Picture.count', -1 do
        delete :destroy, id: @picture
      end
      assert_redirected_to admin_pictures_path
    end

    test 'should render 404 if access new page' do
      assert_raises(ActionController::UrlGenerationError) do
        get :new
      end
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@picture, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@picture, admin_dashboard_path, model_name)
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
      assert ability.cannot?(:create, Picture.new), 'should not be able to create'
      assert ability.cannot?(:read, @picture), 'should not be able to read'
      assert ability.cannot?(:update, @picture), 'should not be able to update'
      assert ability.cannot?(:destroy, @picture), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, Picture.new), 'should not be able to create'
      assert ability.can?(:read, @picture), 'should be able to read'
      assert ability.can?(:update, @picture), 'should be able to update'
      assert ability.can?(:destroy, @picture), 'should be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, Picture.new), 'should be able to create'
      assert ability.can?(:read, @picture), 'should be able to read'
      assert ability.can?(:update, @picture), 'should be able to update'
      assert ability.can?(:destroy, @picture), 'should be able to destroy'
    end

    #
    # == Picture
    #
    test 'should update picture if new picture is sent' do
      attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
      patch :update, id: @picture, picture: { image: attachment }
      picture = assigns(:picture)
      assert_equal picture.image_file_name, 'background-paris.jpg'
      assert_equal picture.image_content_type, 'image/jpeg'
      delete :destroy, id: picture.id
    end

    test 'should destroy all attachments when destroying picture' do
      attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
      patch :update, id: @picture, picture: { image: attachment }

      picture = assigns(:picture)
      existing_styles = []
      picture.image.styles.keys.collect do |style|
        f = picture.image.path(style)
        assert File.exist?(f), "File #{f} should exist"
        existing_styles << f
      end

      delete :destroy, id: picture.id
      existing_styles.each do |f|
        assert_not File.exist?(f), "File #{f} should not exist"
      end
    end

    private

    def initialize_test
      @setting = settings(:one)
      @picture = pictures(:home)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
