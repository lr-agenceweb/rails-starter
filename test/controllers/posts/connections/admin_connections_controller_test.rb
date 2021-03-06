# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == ConnectionsController test
  #
  class ConnectionsControllerTest < ActionController::TestCase
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
      get :show, params: { id: @connection }
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, params: { id: @connection }
      assert_response :success
    end

    test 'should create connection if logged in' do
      assert_difference 'Connection.count' do
        attrs = set_default_record_attrs
        post :create, params: { connection: attrs }
        assert_equal 'Connection', assigns(:connection).type
        assert_equal @administrator.id, assigns(:connection).user_id
        assert_redirected_to admin_connection_path(assigns(:connection))
      end
    end

    test 'should update connection if logged in' do
      patch :update, params: { id: @connection, connection: {} }
      assert_redirected_to admin_connection_path(@connection)
    end

    #
    # == Destroy
    #
    test 'should destroy connection' do
      assert_difference ['Connection.count', 'Link.count'], -1 do
        delete :destroy, params: { id: @connection }
        assert_redirected_to admin_connections_path
      end
    end

    test 'AJAX :: should destroy blog' do
      assert_difference ['Connection.count', 'Link.count'], -1 do
        delete :destroy, params: { id: @connection }, xhr: true
        assert_response :success
        assert_template :destroy
      end
    end

    #
    # == Batch actions
    #
    test 'should return correct value for toggle_online batch action' do
      post :batch_action, params: { batch_action: 'toggle_online', collection_selection: [@connection.id] }
      [@connection].each(&:reload)
      assert_not @connection.online?
    end

    test 'should redirect to back and have correct flash notice for toggle_online batch action' do
      post :batch_action, params: { batch_action: 'toggle_online', collection_selection: [@connection.id] }
      assert_redirected_to admin_connections_path
      assert_equal I18n.t('active_admin.batch_actions.flash'), flash[:notice]
    end

    test 'should redirect to back and have correct flash notice for reset_cache batch action' do
      post :batch_action, params: { batch_action: 'reset_cache', collection_selection: [@connection.id] }
      assert_redirected_to admin_connections_path
      assert_equal I18n.t('active_admin.batch_actions.reset_cache'), flash[:notice]
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@connection, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@connection, admin_dashboard_path, model_name)
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
      assert ability.cannot?(:create, Connection.new), 'should not be able to create'
      assert ability.cannot?(:read, @connection), 'should not be able to read'
      assert ability.cannot?(:update, @connection), 'should not be able to update'
      assert ability.cannot?(:destroy, @connection), 'should not be able to destroy'

      assert ability.cannot?(:toggle_online, @connection), 'should not be able to toggle_online'
      assert ability.cannot?(:reset_cache, @connection), 'should not be able to reset_cache'
    end

    test 'should test abilities for administrator with own LN' do
      ability = Ability.new(@administrator)
      assert ability.can?(:create, Connection.new), 'should be able to create'
      assert ability.can?(:read, @connection), 'should be able to read'
      assert ability.can?(:update, @connection), 'should be able to update'
      assert ability.can?(:destroy, @connection), 'should be able to destroy'

      assert ability.can?(:toggle_online, @connection), 'should be able to toggle_online'
      assert ability.can?(:reset_cache, @connection), 'should be able to reset_cache'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, Connection.new), 'should be able to create'
      assert ability.can?(:read, @connection), 'should be able to read'
      assert ability.can?(:update, @connection), 'should be able to update'
      assert ability.can?(:destroy, @connection), 'should be able to destroy'

      assert ability.can?(:toggle_online, @connection), 'should be able to toggle_online'
      assert ability.can?(:reset_cache, @connection), 'should be able to reset_cache'
    end

    private

    def initialize_test
      @setting = settings(:one)
      @request.env['HTTP_REFERER'] = admin_connections_path

      @connection = posts(:connection)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
