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
    include Devise::Test::ControllerHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should get show page if logged in' do
      get :show, params: { id: @slide }
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, params: { id: @slide }
      assert_response :success
    end

    test 'should update slide if logged in' do
      patch :update, params: { id: @slide, slide: {} }
      assert_redirected_to admin_slide_path(@slide)
    end

    test 'should destroy slide' do
      assert_difference 'Slide.count', -1 do
        delete :destroy, params: { id: @slide }
      end
      assert_redirected_to admin_slides_path
    end

    #
    # == Batch actions
    #
    test 'should return correct value for toggle_online batch action' do
      post :batch_action, params: { batch_action: 'toggle_online', collection_selection: [@slide.id] }
      [@slide].each(&:reload)
      assert_not @slide.online?
    end

    test 'should redirect to back and have correct flash notice for toggle_online batch action' do
      post :batch_action, params: { batch_action: 'toggle_online', collection_selection: [@slide.id] }
      assert_redirected_to admin_slides_path
      assert_equal I18n.t('active_admin.batch_actions.flash'), flash[:notice]
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

      assert ability.cannot?(:toggle_online, @slide), 'should not be able to toggle_online'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, Slide.new), 'should not be able to create'
      assert ability.can?(:read, @slide), 'should be able to read'
      assert ability.can?(:update, @slide), 'should be able to update'
      assert ability.can?(:destroy, @slide), 'should be able to destroy'

      assert ability.can?(:toggle_online, @slide), 'should be able to toggle_online'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, Slide.new), 'should be able to create'
      assert ability.can?(:read, @slide), 'should be able to read'
      assert ability.can?(:update, @slide), 'should be able to update'
      assert ability.can?(:destroy, @slide), 'should be able to destroy'

      assert ability.can?(:toggle_online, @slide), 'should be able to toggle_online'
    end

    #
    # == Slide
    #
    test 'should update slide if new picture is sent' do
      attachment = fixture_file_upload 'images/slide.jpg', 'image/jpeg'
      patch :update, params: { id: @slide, slide: { image: attachment } }
      slide = assigns(:slide)
      assert_equal slide.image_file_name, 'slide.jpg'
      assert_equal slide.image_content_type, 'image/jpeg'
      delete :destroy, params: { id: slide.id }
    end

    test 'should destroy all attachments when destroying slide' do
      attachment = fixture_file_upload 'images/slide.jpg', 'image/jpeg'
      patch :update, params: { id: @slide, slide: { image: attachment } }

      slide = assigns(:slide)
      existing_styles = []
      slide.image.styles.keys.collect do |style|
        f = slide.image.path(style)
        assert File.exist?(f), "File #{f} should exist"
        existing_styles << f
      end

      delete :destroy, params: { id: slide.id }
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
      @request.env['HTTP_REFERER'] = admin_slides_path

      @slide = slides(:slide_one)
      @slider_module = optional_modules(:slider)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
