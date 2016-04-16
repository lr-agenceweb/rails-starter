# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == SlidesController test
  #
  class SlidesControllerTest < ActionController::TestCase
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
      get :show, id: @slide
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @slide
      assert_response :success
    end

    test 'should update slide if logged in' do
      patch :update, id: @slide, slide: {}
      assert_redirected_to admin_slide_path(@slide)
    end

    test 'should destroy slide' do
      assert_difference 'Slide.count', -1 do
        delete :destroy, id: @slide
      end
      assert_redirected_to admin_slides_path
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
      assert ability.cannot?(:create, Slide.new), 'should not be able to create'
      assert ability.cannot?(:read, @slide), 'should not be able to read'
      assert ability.cannot?(:update, @slide), 'should not be able to update'
      assert ability.cannot?(:destroy, @slide), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, Slide.new), 'should not be able to create'
      assert ability.can?(:read, @slide), 'should be able to read'
      assert ability.can?(:update, @slide), 'should be able to update'
      assert ability.can?(:destroy, @slide), 'should be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, Slide.new), 'should be able to create'
      assert ability.can?(:read, @slide), 'should be able to read'
      assert ability.can?(:update, @slide), 'should be able to update'
      assert ability.can?(:destroy, @slide), 'should be able to destroy'
    end

    #
    # == Slide
    #
    test 'should update slide if new picture is sent' do
      attachment = fixture_file_upload 'images/slide.jpg', 'image/jpeg'
      patch :update, id: @slide, slide: { image: attachment }
      slide = assigns(:slide)
      assert_equal slide.image_file_name, 'slide.jpg'
      assert_equal slide.image_content_type, 'image/jpeg'
      delete :destroy, id: slide.id
    end

    test 'should destroy all attachments when destroying slide' do
      attachment = fixture_file_upload 'images/slide.jpg', 'image/jpeg'
      patch :update, id: @slide, slide: { image: attachment }

      slide = assigns(:slide)
      existing_styles = []
      slide.image.styles.keys.collect do |style|
        f = slide.image.path(style)
        assert File.exist?(f), "File #{f} should exist"
        existing_styles << f
      end

      delete :destroy, id: slide.id
      existing_styles.each do |f|
        assert_not File.exist?(f), "File #{f} should not exist"
      end
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@slide, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@slide, admin_dashboard_path, model_name)
    end

    #
    # == Module disabled
    #
    test 'should not access page if slider module is disabled' do
      disable_optional_module @super_administrator, @slider_module, 'Slider' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@slide, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@slide, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@slide, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @setting = settings(:one)
      @slide = slides(:slide_one)
      @slider_module = optional_modules(:slider)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
