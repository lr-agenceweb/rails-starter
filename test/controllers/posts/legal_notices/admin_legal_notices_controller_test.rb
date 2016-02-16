require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == LegalNoticesController test
  #
  class LegalNoticesControllerTest < ActionController::TestCase
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
      get :show, id: @legal_notice_admin
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @legal_notice_admin
      assert_response :success
    end

    test 'should create legal_notice if logged in' do
      assert_difference 'LegalNotice.count' do
        post :create, legal_notice: {}
        assert_equal 'LegalNotice', assigns(:legal_notice).type
        assert_equal @administrator.id, assigns(:legal_notice).user_id
        assert_redirected_to admin_legal_notice_path(assigns(:legal_notice))
      end
    end

    test 'should update legal_notice if logged in' do
      patch :update, id: @legal_notice_admin, legal_notice: {}
      assert_redirected_to admin_legal_notice_path(@legal_notice_admin)
    end

    test 'should destroy own legal_notice article' do
      assert_difference 'LegalNotice.count', -1 do
        delete :destroy, id: @legal_notice_admin
      end
      assert_redirected_to admin_legal_notices_path
    end

    test 'should not destroy legal_notice for SA' do
      assert_no_difference 'LegalNotice.count' do
        delete :destroy, id: @legal_notice_super_admin
      end
      assert_redirected_to admin_dashboard_path
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
    end

    test 'should test abilities for administrator with own LN' do
      ability = Ability.new(@administrator)
      assert ability.can?(:create, LegalNotice.new), 'should be able to create'
      assert ability.can?(:read, @legal_notice_admin), 'should be able to read'
      assert ability.can?(:update, @legal_notice_admin), 'should be able to update'
      assert ability.can?(:destroy, @legal_notice_admin), 'should be able to destroy'
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
    end

    test 'should test abilities for super_administrator with own LN' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:read, @legal_notice_super_admin), 'should be able to read'
      assert ability.can?(:update, @legal_notice_super_admin), 'should be able to update'
      assert ability.can?(:destroy, @legal_notice_super_admin), 'should be able to destroy'
    end

    private

    def initialize_test
      @setting = settings(:one)
      @legal_notice_super_admin = posts(:legal_notice_super_admin)
      @legal_notice_admin = posts(:legal_notice_admin)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
