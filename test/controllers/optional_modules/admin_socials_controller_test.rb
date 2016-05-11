
# frozen_string_literal: true
require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == SocialsController test
  #
  class SocialsControllerTest < ActionController::TestCase
    include Devise::TestHelpers
    include Rails.application.routes.url_helpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should get show page if logged in' do
      get :show, id: @social
      assert_response :success
    end

    test 'should get edit page if logged in' do
      get :edit, id: @social
      assert_response :success
    end

    test 'should update social if logged in' do
      patch :update, id: @social, social: {}
      assert_redirected_to admin_social_path(assigns(:social))
    end

    #
    # == Destroy
    #
    test 'should not destroy social' do
      assert_no_difference ['Social.count'] do
        delete :destroy, id: @social
      end
      assert_redirected_to admin_dashboard_path
    end

    #
    # == Batch actions
    #
    test 'should return correct value for toggle_enabled batch action' do
      post :batch_action, batch_action: 'toggle_enabled', collection_selection: [@social.id]
      [@social].each(&:reload)
      assert_not @social.enabled?
    end

    test 'should redirect to back and have correct flash notice for toggle_enabled batch action' do
      post :batch_action, batch_action: 'toggle_enabled', collection_selection: [@social.id]
      assert_redirected_to admin_socials_path
      assert_equal I18n.t('active_admin.batch_actions.flash'), flash[:notice]
    end

    #
    # == Validation rules
    #
    test 'should remove forbidden key from object if administrator' do
      patch :update, id: @social, social: { title: 'Google+', kind: 'share' }
      assert_equal 'Facebook', assigns(:social).title
      assert_equal 'follow', assigns(:social).object.kind
      assert_equal I18n.t('social.follow'), assigns(:social).kind
    end

    test 'should not save if title is not allowed' do
      sign_in @super_administrator
      assert_no_difference ['Social.count'] do
        post :create, social: { title: 'forbidden', kind: 'share' }
      end
      assert_not assigns(:social).valid?
    end

    test 'should not save if kind is not allowed' do
      sign_in @super_administrator
      assert_no_difference ['Social.count'] do
        post :create, social: { title: 'Facebook', kind: 'forbidden' }
      end
      assert_not assigns(:social).valid?
    end

    test 'should not save if link is not correct' do
      sign_in @super_administrator
      assert_no_difference ['Social.count'] do
        post :create, social: { title: 'Facebook', kind: 'follow', link: 'http://forbidden' }
      end
      assert_not assigns(:social).valid?
    end

    test 'should not save if link is not present with follow kind' do
      sign_in @super_administrator
      assert_no_difference ['Social.count'] do
        post :create, social: { title: 'Facebook', kind: 'follow' }
      end
      assert_not assigns(:social).valid?
    end

    test 'should not update if font awesome ikon is not allowed' do
      sign_in @administrator
      patch :update, id: @social_facebook_share, social: { font_ikon: 'forbidden_value' }
      assert_not assigns(:social).valid?
    end

    test 'should update if font awesome ikon is allowed' do
      sign_in @administrator
      patch :update, id: @social_facebook_share, social: { font_ikon: 'twitter' }
      assert assigns(:social).valid?
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
      assert ability.cannot?(:create, Social.new), 'should not be able to create'
      assert ability.cannot?(:read, @social), 'should not be able to read'
      assert ability.cannot?(:update, @social), 'should not be able to update'
      assert ability.cannot?(:destroy, @social), 'should not be able to destroy'

      assert ability.cannot?(:toggle_enabled, @social), 'should not be able to toggle_enabled'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, Social.new), 'should not be able to create'
      assert ability.can?(:read, @social), 'should be able to read'
      assert ability.can?(:update, @social), 'should be able to update'
      assert ability.cannot?(:destroy, @social), 'should not be able to destroy'

      assert ability.can?(:toggle_enabled, @social), 'should be able to toggle_enabled'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, Social.new), 'should be able to create'
      assert ability.can?(:read, @social), 'should be able to read'
      assert ability.can?(:update, @social), 'should be able to update'
      assert ability.can?(:destroy, @social), 'should be able to destroy'

      assert ability.can?(:toggle_enabled, @social), 'should be able to toggle_enabled'
    end

    #
    # == Crud actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@social, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      assert_crud_actions(@social, admin_dashboard_path, model_name)
    end

    #
    # == Module disabled
    #
    test 'should not access page if social module is disabled' do
      disable_optional_module @super_administrator, @social_module, 'Social' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@social, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@social, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@social, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @setting = settings(:one)
      @request.env['HTTP_REFERER'] = admin_socials_path

      @social = socials(:facebook_follow)
      @social_facebook_share = socials(:facebook_share)
      @social_module = optional_modules(:social)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
