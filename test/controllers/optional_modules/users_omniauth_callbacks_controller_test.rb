require 'test_helper'

#
# == Users namespace
#
module Users
  #
  # == OmniauthCallbacksController Test
  #
  class OmniauthCallbacksControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Connect me
    #
    test 'should refuse to login user and redirect to login if doesn\'t exists' do
      get :facebook
      assert assigns(:user).blank?
      assert_equal I18n.t('omniauth.login.not_exist', provider: 'Facebook'), flash[:alert]
      assert_redirected_to new_user_session_url
    end

    test 'should connect user if already exists in DB' do
      set_rafa_omniauth
      get :facebook
      assert_not assigns(:user).blank?
      assert_equal I18n.t('devise.omniauth_callbacks.success', kind: 'Facebook'), flash[:notice]
      assert_redirected_to admin_dashboard_path
    end

    #
    # == Link me
    #
    test 'should return error if user already linked to Facebook' do
      set_rafa_omniauth
      sign_in @facebook_user
      get :facebook
      assert_not assigns(:errors).empty?
      assert_equal I18n.t('omniauth.email.already_linked', provider: 'Facebook'), assigns(:error)
      assert_redirected_to admin_user_path(@facebook_user)
    end

    test 'should return error if Facebook email doesn\' match classic email' do
      sign_in @facebook_user
      get :facebook
      assert_not assigns(:errors).empty?
      assert_equal I18n.t('omniauth.email.not_match', provider: 'Facebook'), assigns(:error)
      assert_redirected_to admin_user_path(@facebook_user)
    end

    test 'should be all good if no errors' do
      set_admin_omniauth
      sign_in @administrator
      get :facebook
      assert assigns(:errors).empty?
      assert_not assigns(:user).blank?
      assert_equal I18n.t('devise.omniauth_callbacks.success', kind: 'Facebook'), flash[:notice]
      assert_redirected_to admin_user_path(@administrator)
    end

    #
    # == Unlink
    #
    test 'should not unlink omniauth if user is not same as current connected' do
      sign_in @administrator
      get :unlink, provider: 'facebook', id: @facebook_user.id
      assert_equal I18n.t('omniauth.unlink.alert.wrong_identity'), flash[:alert]
      assert_redirected_to admin_user_path(@administrator)
    end

    test 'should not unlink omniauth if user is not omniauth user' do
      sign_in @administrator
      get :unlink, provider: 'facebook', id: @subscriber.id
      assert_equal I18n.t('omniauth.unlink.alert.wrong_identity'), flash[:alert]
      assert_redirected_to admin_user_path(@administrator)
    end

    test 'should unlink omniauth if all good' do
      sign_in @facebook_user
      get :unlink, provider: 'facebook', id: @facebook_user.id
      assert_equal I18n.t('omniauth.unlink.alert.success', provider: 'Facebook'), flash[:notice]
      assert_redirected_to admin_user_path(@facebook_user)
    end

    #
    # == Abilities
    #
    test 'should test abilities for subscriber' do
      sign_in @subscriber
      ability = Ability.new(@subscriber)
      assert ability.can?(:unlink, @subscriber), 'should be able to unlink'
      assert ability.cannot?(:unlink, @administrator), 'should not be able to unlink'
      assert ability.cannot?(:unlink, @super_administrator), 'should not be able to unlink'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.can?(:unlink, @administrator), 'should be able to unlink'
      assert ability.cannot?(:unlink, @subscriber), 'should not be able to unlink'
      assert ability.cannot?(:unlink, @super_administrator), 'should not be able to unlink'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:unlink, @super_administrator), 'should be able to unlink'
      assert ability.cannot?(:unlink, @subscriber), 'should not be able to unlink'
      assert ability.cannot?(:unlink, @administrator), 'should not be able to unlink'
    end

    #
    # == Module or provider disabled
    #
    test 'should not access page if social_connect module is disabled' do
      @social_connect_module.update_attribute(:enabled, false)
      assert_raises(ActionController::RoutingError) do
        get :facebook
      end
    end

    test 'should not access page if social_connect setting is disabled' do
      @social_connect_setting.update_attribute(:enabled, false)
      assert_raises(ActionController::RoutingError) do
        get :facebook
      end
    end

    test 'should not access page if facebook provider is disabled' do
      @social_provider_facebook.update_attribute(:enabled, false)
      assert_raises(ActionController::RoutingError) do
        get :facebook
      end
    end

    test 'should not access page if twitter provider is disabled' do
      @social_provider_twitter.update_attribute(:enabled, false)
      assert_raises(ActionController::RoutingError) do
        get :twitter
      end
    end

    test 'should not access page if google provider is disabled' do
      @social_provider_google.update_attribute(:enabled, false)
      assert_raises(ActionController::RoutingError) do
        get :google_oauth2
      end
    end

    # Unlink
    test 'should not unlink user if social_connect module is disabled' do
      @social_connect_module.update_attribute(:enabled, false)
      sign_in @facebook_user
      assert_raises(ActionController::RoutingError) do
        get :unlink, provider: 'facebook', id: @facebook_user.id
      end
    end

    test 'should not unlink user if social_connect setting is disabled' do
      @social_connect_setting.update_attribute(:enabled, false)
      sign_in @facebook_user
      assert_raises(ActionController::RoutingError) do
        get :unlink, provider: 'facebook', id: @facebook_user.id
      end
    end

    test 'should not unlink user if facebook provider is disabled' do
      @social_provider_facebook.update_attribute(:enabled, false)
      assert_raises(ActionController::RoutingError) do
        get :unlink, provider: 'facebook', id: @facebook_user.id
      end
    end

    private

    def initialize_test
      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      @facebook_user = users(:rafa)

      @social_provider_facebook = social_providers(:facebook)
      @social_provider_twitter = social_providers(:twitter)
      @social_provider_google = social_providers(:google)

      @social_connect_module = optional_modules(:social_connect)
      @social_connect_setting = social_connect_settings(:one)

      request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
        provider: 'facebook',
        uid: 2_456_789,
        info: {
          name: 'Tester',
          email: 'facebook@omniauth.com'
        }
      )
    end

    def set_rafa_omniauth
      request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
        provider: 'facebook',
        uid: 123_456_789,
        info: {
          name: 'rafa',
          email: 'rafa@nadal.es'
        }
      )
    end

    def set_admin_omniauth
      request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
        provider: 'facebook',
        uid: 5_320_619,
        info: {
          name: 'Bob',
          email: 'bob@test.fr'
        }
      )
    end
  end
end
