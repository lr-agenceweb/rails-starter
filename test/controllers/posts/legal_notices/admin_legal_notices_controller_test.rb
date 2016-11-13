# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == LegalNoticesController test
  #
  class LegalNoticesControllerTest < ActionController::TestCase
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
      get :show, params: { id: @legal_notice_admin.id }
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, params: { id: @legal_notice_admin.id }
      assert_response :success
    end

    test 'should create legal_notice if logged in' do
      assert_difference 'LegalNotice.count' do
        attrs = set_default_record_attrs
        post :create, params: { legal_notice: attrs }
        assert_equal 'LegalNotice', assigns(:legal_notice).type
        assert_equal @administrator.id, assigns(:legal_notice).user_id
        assert_redirected_to admin_legal_notice_path(assigns(:legal_notice))
      end
    end

    test 'should update legal_notice if logged in' do
      patch :update, params: { id: @legal_notice_admin.id, legal_notice: {} }
      assert_redirected_to admin_legal_notice_path(@legal_notice_admin)
    end

    test 'should destroy own legal_notice article' do
      assert_difference 'LegalNotice.count', -1 do
        delete :destroy, params: { id: @legal_notice_admin.id }
      end
      assert_redirected_to admin_legal_notices_path
    end

    test 'should not destroy legal_notice for SA' do
      assert_no_difference 'LegalNotice.count' do
        delete :destroy, params: { id: @legal_notice_super_admin.id }
      end
      assert_redirected_to admin_dashboard_path
    end

    #
    # == Batch actions
    #
    test 'should return correct value for toggle_online batch action' do
      post :batch_action, params: { batch_action: 'toggle_online', collection_selection: [@legal_notice_super_admin.id, @legal_notice_admin.id] }
      [@legal_notice_super_admin, @legal_notice_admin].each(&:reload)
      assert_not @legal_notice_super_admin.online?
      assert_not @legal_notice_admin.online?
    end

    test 'should redirect to back and have correct flash notice for toggle_online batch action' do
      post :batch_action, params: { batch_action: 'toggle_online', collection_selection: [@legal_notice_admin.id] }
      assert_redirected_to admin_legal_notices_path
      assert_equal I18n.t('active_admin.batch_actions.flash'), flash[:notice]
    end

    test 'should redirect to back and have correct flash notice for reset_cache batch action' do
      post :batch_action, params: { batch_action: 'reset_cache', collection_selection: [@legal_notice_admin.id] }
      assert_redirected_to admin_legal_notices_path
      assert_equal I18n.t('active_admin.batch_actions.reset_cache'), flash[:notice]
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@legal_notice_admin, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@legal_notice_admin, admin_dashboard_path, model_name)
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
      assert ability.cannot?(:create, LegalNotice.new), 'should not be able to create'
      assert ability.cannot?(:read, @legal_notice_admin), 'should not be able to read'
      assert ability.cannot?(:update, @legal_notice_admin), 'should not be able to update'
      assert ability.cannot?(:destroy, @legal_notice_admin), 'should not be able to destroy'

      assert ability.cannot?(:toggle_online, @legal_notice_admin), 'should not be able to toggle_online'
      assert ability.cannot?(:reset_cache, @legal_notice_admin), 'should not be able to reset_cache'
    end

    test 'should test abilities for administrator with own LN' do
      ability = Ability.new(@administrator)
      assert ability.can?(:create, LegalNotice.new), 'should be able to create'
      assert ability.can?(:read, @legal_notice_admin), 'should be able to read'
      assert ability.can?(:update, @legal_notice_admin), 'should be able to update'
      assert ability.can?(:destroy, @legal_notice_admin), 'should be able to destroy'

      assert ability.can?(:toggle_online, @legal_notice_admin), 'should be able to toggle_online'
      assert ability.can?(:reset_cache, @legal_notice_admin), 'should be able to reset_cache'
    end

    test 'should test abilities for administrator with SA LN' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:read, @legal_notice_super_admin), 'should not be able to read'
      assert ability.cannot?(:update, @legal_notice_super_admin), 'should not be able to update'
      assert ability.cannot?(:destroy, @legal_notice_super_admin), 'should not be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, LegalNotice.new), 'should be able to create'
      assert ability.can?(:read, @legal_notice_admin), 'should be able to read'
      assert ability.can?(:update, @legal_notice_admin), 'should be able to update'
      assert ability.can?(:destroy, @legal_notice_admin), 'should be able to destroy'

      assert ability.can?(:toggle_online, @legal_notice_admin), 'should be able to toggle_online'
      assert ability.can?(:reset_cache, @legal_notice_admin), 'should be able to reset_cache'
    end

    test 'should test abilities for super_administrator with own LN' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:read, @legal_notice_super_admin), 'should be able to read'
      assert ability.can?(:update, @legal_notice_super_admin), 'should be able to update'
      assert ability.can?(:destroy, @legal_notice_super_admin), 'should be able to destroy'

      assert ability.can?(:toggle_online, @legal_notice_super_admin), 'should be able to toggle_online'
      assert ability.can?(:reset_cache, @legal_notice_super_admin), 'should be able to reset_cache'
    end

    private

    def initialize_test
      @setting = settings(:one)
      @request.env['HTTP_REFERER'] = admin_legal_notices_path

      @legal_notice_super_admin = posts(:legal_notice_super_admin)
      @legal_notice_admin = posts(:legal_notice_admin)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
