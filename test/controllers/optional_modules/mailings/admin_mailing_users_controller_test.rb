# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == MailingUsersController test
  #
  class MailingUsersControllerTest < ActionController::TestCase
    include Devise::Test::ControllerHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, params: { id: @mailing_user }
      assert_response :success
    end

    test 'should get show page if logged in' do
      get :show, params: { id: @mailing_user }
      assert_response :success
    end

    # Valid params
    test 'should update mailing_user if logged in' do
      patch :update, params: { id: @mailing_user, mailing_user: {} }
      assert_redirected_to admin_mailing_user_path(@mailing_user)
    end

    # Invalid params
    test 'should not update if lang params is not allowed' do
      patch :update, params: { id: @mailing_user, mailing_user: { lang: 'de' } }
      assert_not assigns(:mailing_user).valid?
    end

    test 'should render edit template if lang is not allowed' do
      patch :update, params: { id: @mailing_user, mailing_user: { lang: 'de' } }
      assert_template :edit
    end

    #
    # == Destroy
    #
    test 'should not destroy user if logged in as subscriber' do
      sign_in @subscriber
      assert_no_difference 'MailingUser.count' do
        delete :destroy, params: { id: @mailing_user }
      end
    end

    test 'should destroy mailing user if logged in as administrator' do
      assert_difference 'MailingUser.count', -1 do
        delete :destroy, params: { id: @mailing_user }
      end
    end

    test 'should redirect to mailing users path after destroy' do
      delete :destroy, params: { id: @mailing_user }
      assert_redirected_to admin_mailing_users_path
    end

    #
    # == Batch actions
    #
    test 'should return correct value for toggle_archive_customer batch action' do
      post :batch_action, params: { batch_action: 'toggle_archive_customer', collection_selection: [@mailing_user.id] }
      [@mailing_user].each(&:reload)
      assert @mailing_user.archive?
    end

    test 'should redirect to back and have correct flash notice for toggle_archive_customer batch action' do
      post :batch_action, params: { batch_action: 'toggle_archive_customer', collection_selection: [@mailing_user.id] }
      assert_redirected_to admin_mailing_users_path
      assert_equal I18n.t('active_admin.batch_actions.flash'), flash[:notice]
    end

    #
    # == Subscriber
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@mailing_user, new_user_session_path, model_name, no_show: true)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@mailing_user, admin_dashboard_path, model_name, no_show: true)
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
      assert ability.cannot?(:create, MailingUser.new), 'should not be able to create'
      assert ability.cannot?(:read, @mailing_user), 'should not be able to read'
      assert ability.cannot?(:update, @mailing_user), 'should not be able to update'
      assert ability.cannot?(:destroy, @mailing_user), 'should not be able to destroy'

      assert ability.cannot?(:toggle_archive_customer, @mailing_user), 'should not be able to toggle_archive_customer'

      @mailing_module.update_attribute(:enabled, false)
      ability = Ability.new(@subscriber)
      assert ability.cannot?(:create, MailingUser.new), 'should not be able to create'
      assert ability.cannot?(:read, @mailing_user), 'should not be able to read'
      assert ability.cannot?(:update, @mailing_user), 'should not be able to update'
      assert ability.cannot?(:destroy, @mailing_user), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.can?(:create, MailingUser.new), 'should be able to create'
      assert ability.can?(:read, @mailing_user), 'should be able to read'
      assert ability.can?(:update, @mailing_user), 'should be able to update'
      assert ability.can?(:destroy, @mailing_user), 'should be able to destroy'

      assert ability.can?(:toggle_archive_customer, @mailing_user), 'should be able to toggle_archive_customer'

      @mailing_module.update_attribute(:enabled, false)
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, MailingUser.new), 'should not be able to create'
      assert ability.cannot?(:read, @mailing_user), 'should not be able to read'
      assert ability.cannot?(:update, @mailing_user), 'should not be able to update'
      assert ability.cannot?(:destroy, @mailing_user), 'should not be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, MailingUser.new), 'should be able to create'
      assert ability.can?(:read, @mailing_user), 'should be able to read'
      assert ability.can?(:update, @mailing_user), 'should be able to update'
      assert ability.can?(:destroy, @mailing_user), 'should be able to destroy'

      assert ability.can?(:toggle_archive_customer, @mailing_user), 'should be able to toggle_archive_customer'

      @mailing_module.update_attribute(:enabled, false)
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, MailingUser.new), 'should not be able to create'
      assert ability.cannot?(:read, @mailing_user), 'should not be able to read'
      assert ability.cannot?(:update, @mailing_user), 'should not be able to update'
      assert ability.cannot?(:destroy, @mailing_user), 'should not be able to destroy'
    end

    #
    # == Module disabled
    #
    test 'should not access page if mailing module is disabled' do
      disable_optional_module @super_administrator, @mailing_module, 'Mailing' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@mailing_user, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@mailing_user, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@mailing_user, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @setting = settings(:one)
      @request.env['HTTP_REFERER'] = admin_mailing_users_path

      @mailing_user = mailing_users(:one)
      @mailing_module = optional_modules(:mailing)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
