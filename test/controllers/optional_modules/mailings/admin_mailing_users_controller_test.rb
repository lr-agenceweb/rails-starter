require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == MailingUsersController test
  #
  class MailingUsersControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @mailing_user
      assert_response :success
    end

    test 'should render 404 if access show page' do
      get :show, id: @mailing_user
      assert_response :success
    end

    # Valid params
    test 'should update mailing_user if logged in' do
      patch :update, id: @mailing_user, mailing_user: {}
      assert_redirected_to admin_mailing_user_path(@mailing_user)
    end

    # Invalid params
    test 'should not update if lang params is not allowed' do
      patch :update, id: @mailing_user, mailing_user: { lang: 'de' }
      assert_not assigns(:mailing_user).valid?
    end

    test 'should render edit template if lang is not allowed' do
      patch :update, id: @mailing_user, mailing_user: { lang: 'de' }
      assert_template :edit
    end

    #
    # == Destroy
    #
    test 'should not destroy user if logged in as subscriber' do
      sign_in @subscriber
      assert_no_difference 'MailingUser.count' do
        delete :destroy, id: @mailing_user
      end
    end

    test 'should destroy mailing user if logged in as administrator' do
      assert_difference 'MailingUser.count', -1 do
        delete :destroy, id: @mailing_user
      end
    end

    test 'should redirect to mailing users path after destroy' do
      delete :destroy, id: @mailing_user
      assert_redirected_to admin_mailing_users_path
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
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.can?(:create, MailingUser.new), 'should be able to create'
      assert ability.can?(:read, @mailing_user), 'should be able to read'
      assert ability.can?(:update, @mailing_user), 'should be able to update'
      assert ability.can?(:destroy, @mailing_user), 'should be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, MailingUser.new), 'should be able to create'
      assert ability.can?(:read, @mailing_user), 'should be able to read'
      assert ability.can?(:update, @mailing_user), 'should be able to update'
      assert ability.can?(:destroy, @mailing_user), 'should be able to destroy'
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
      @mailing_user = mailing_users(:one)
      @mailing_module = optional_modules(:mailing)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
