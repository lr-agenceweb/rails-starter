# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == AboutsController test
  #
  class AboutsControllerTest < ActionController::TestCase
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
      get :show, id: @about
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @about
      assert_response :success
    end

    test 'should create if logged in' do
      assert_difference 'About.count' do
        attrs = set_default_record_attrs
        post :create, about: attrs
        assert_equal 'About', assigns(:about).type
        assert_equal @administrator.id, assigns(:about).user_id
        assert_redirected_to admin_about_path(assigns(:about))
      end
    end

    test 'should update about if logged in' do
      patch :update, id: @about, about: {}
      assert_redirected_to admin_about_path(@about)
    end

    test 'should destroy about' do
      assert_difference ['About.count', 'Referencement.count'], -1 do
        delete :destroy, id: @about
      end
      assert_redirected_to admin_abouts_path
    end

    #
    # == Batch actions
    #
    test 'should return correct value for toggle_online batch action' do
      post :batch_action, batch_action: 'toggle_online', collection_selection: [@about.id]
      [@about].each(&:reload)
      assert_not @about.online?
    end

    test 'should redirect to back and have correct flash notice for toggle_online batch action' do
      post :batch_action, batch_action: 'toggle_online', collection_selection: [@about.id]
      assert_redirected_to admin_abouts_path
      assert_equal I18n.t('active_admin.batch_actions.flash'), flash[:notice]
    end

    test 'should redirect to back and have correct flash notice for reset_cache batch action' do
      post :batch_action, batch_action: 'reset_cache', collection_selection: [@about.id]
      assert_redirected_to admin_abouts_path
      assert_equal I18n.t('active_admin.batch_actions.reset_cache'), flash[:notice]
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
      assert ability.cannot?(:create, About.new), 'should not be able to create'
      assert ability.cannot?(:read, @about), 'should not be able to read'
      assert ability.cannot?(:update, @about), 'should not be able to update'
      assert ability.cannot?(:destroy, @about), 'should not be able to destroy'

      assert ability.cannot?(:read, @about_super_administrator), 'should not be able to read super_administrator'
      assert ability.cannot?(:update, @about_super_administrator), 'should not be able to update super_administrator'
      assert ability.cannot?(:destroy, @about_super_administrator), 'should not be able to destroy super_administrator'

      assert ability.cannot?(:toggle_online, @about), 'should not be able to toggle_online'
      assert ability.cannot?(:reset_cache, @about), 'should not be able to reset_cache'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.can?(:create, About.new), 'should be able to create'
      assert ability.can?(:read, @about), 'should be able to read'
      assert ability.can?(:update, @about), 'should be able to update'
      assert ability.can?(:destroy, @about), 'should be able to destroy'

      assert ability.cannot?(:read, @about_super_administrator), 'should not be able to read super_administrator'
      assert ability.cannot?(:update, @about_super_administrator), 'should not be able to update super_administrator'
      assert ability.cannot?(:destroy, @about_super_administrator), 'should not be able to destroy super_administrator'

      assert ability.can?(:toggle_online, @about), 'should be able to toggle_online'
      assert ability.can?(:reset_cache, @about), 'should be able to reset_cache'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, About.new), 'should be able to create'
      assert ability.can?(:read, @about), 'should be able to read'
      assert ability.can?(:update, @about), 'should be able to update'
      assert ability.can?(:destroy, @about), 'should be able to destroy'

      assert ability.can?(:read, @about_super_administrator), 'should be able to read super_administrator'
      assert ability.can?(:update, @about_super_administrator), 'should be able to update super_administrator'
      assert ability.can?(:destroy, @about_super_administrator), 'should be able to destroy super_administrator'

      assert ability.can?(:toggle_online, @about), 'should be able to toggle_online'
      assert ability.can?(:reset_cache, @about), 'should be able to reset_cache'
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@about, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@about, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @setting = settings(:one)
      @request.env['HTTP_REFERER'] = admin_abouts_path

      @about = posts(:about_2)
      @about_super_administrator = posts(:about)
      @comment_module = optional_modules(:comment)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
