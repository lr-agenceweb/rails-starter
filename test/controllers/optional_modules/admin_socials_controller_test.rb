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
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@social, new_user_session_path)
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should access show page if logged in' do
      get :show, id: @social
      assert_response :success
    end

    test 'should access edit page if logged in' do
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
    # == Validation rules
    #
    test 'should remove forbidden key from object if administrator' do
      patch :update, id: @social, social: { title: 'Google+', kind: 'share' }
      assert_equal 'Facebook', assigns(:social).title
      assert_equal 'follow', assigns(:social).kind
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
        post :create, social: { title: 'Facebook', kind: 'share', link: 'http://forbidden' }
      end
      assert_not assigns(:social).valid?
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
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, Social.new), 'should not be able to create'
      assert ability.can?(:read, @social), 'should be able to read'
      assert ability.can?(:update, @social), 'should be able to update'
      assert ability.cannot?(:destroy, @social), 'should not be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, Social.new), 'should be able to create'
      assert ability.can?(:read, @social), 'should be able to read'
      assert ability.can?(:update, @social), 'should be able to update'
      assert ability.can?(:destroy, @social), 'should be able to destroy'
    end

    #
    # == Subscriber
    #
    test 'should redirect to dashboard page if trying to access social as subscriber' do
      sign_in @subscriber
      assert_crud_actions(@social, admin_dashboard_path)
    end

    #
    # == Module disabled
    #
    test 'should not access page if social module is disabled' do
      disable_optional_module @super_administrator, @social_module, 'Social' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@social, admin_dashboard_path)
      sign_in @administrator
      assert_crud_actions(@social, admin_dashboard_path)
      sign_in @subscriber
      assert_crud_actions(@social, admin_dashboard_path)
    end

    private

    def initialize_test
      @social = socials(:facebook_follow)
      @social_module = optional_modules(:social)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
