require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == NewsletterUsersController test
  #
  class NewsletterUsersControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == Routes / Templates / Responses
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@newsletter_user, new_user_session_path)
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should show edit page if logged in' do
      get :edit, id: @newsletter_user
      assert_response :success
    end

    # Valid params
    test 'should update newsletter_user if logged in' do
      patch :update, id: @newsletter_user, newsletter_user: {}
      assert_redirected_to admin_newsletter_users_path
    end

    test 'should update newsletter_user role' do
      patch :update, id: @newsletter_user, newsletter_user: { role: 'tester' }
      assert_equal 'tester', assigns(:newsletter_user).role
    end

    # Invalid params
    test 'should not update newsletter_user if lang params is not allowed' do
      patch :update, id: @newsletter_user, newsletter_user: { lang: 'de' }
      assert_not assigns(:newsletter_user).valid?
    end

    test 'should not update newsletter_user role if role params not allowed' do
      patch :update, id: @newsletter_user, newsletter_user: { role: 'administrator' }
      assert_not assigns(:newsletter_user).valid?
    end

    test 'should not update newsletter_user if email params is changed' do
      patch :update, id: @newsletter_user, newsletter_user: { email: 'test@test.com' }
      assert_equal @newsletter_user.email, assigns(:newsletter_user).email
    end

    test 'should render edit template if lang is not allowed' do
      patch :update, id: @newsletter_user, newsletter_user: { lang: 'de' }
      assert_template :edit
    end

    test 'should render edit template if role is not allowed' do
      patch :update, id: @newsletter_user, newsletter_user: { role: 'administrator' }
      assert_template :edit
    end

    #
    # == Destroy
    #
    test 'should not destroy user if logged in as subscriber' do
      sign_in @subscriber
      assert_no_difference 'NewsletterUser.count' do
        delete :destroy, id: @newsletter_user
      end
    end

    test 'should destroy newsletter if logged in as administrator' do
      assert_difference 'NewsletterUser.count', -1 do
        delete :destroy, id: @newsletter_user
      end
    end

    test 'should redirect to newsletter users path after destroy' do
      delete :destroy, id: @newsletter_user
      assert_redirected_to admin_newsletter_users_path
    end

    #
    # == Subscriber
    #
    test 'should redirect to dashboard page if trying to access newsletter_user as subscriber' do
      sign_in @subscriber
      assert_crud_actions(@newsletter_user, admin_dashboard_path)
    end

    #
    # == Abilities
    #
    test 'should test abilities for subscriber' do
      sign_in @subscriber
      ability = Ability.new(@subscriber)
      assert ability.cannot?(:create, NewsletterUser.new), 'should not be able to create'
      assert ability.cannot?(:read, NewsletterUser.new), 'should not be able to read'
      assert ability.cannot?(:update, NewsletterUser.new), 'should not be able to update'
      assert ability.cannot?(:destroy, NewsletterUser.new), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.can?(:create, NewsletterUser.new), 'should be able to create'
      assert ability.can?(:read, NewsletterUser.new), 'should be able to read'
      assert ability.can?(:update, NewsletterUser.new), 'should be able to update'
      assert ability.can?(:destroy, NewsletterUser.new), 'should be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.can?(:create, NewsletterUser.new), 'should be able to create'
      assert ability.can?(:read, NewsletterUser.new), 'should be able to read'
      assert ability.can?(:update, NewsletterUser.new), 'should be able to update'
      assert ability.can?(:destroy, NewsletterUser.new), 'should be able to destroy'
    end

    #
    # == Module disabled
    #
    test 'should not access page if newsletter module is disabled' do
      disable_optional_module @super_administrator, @newsletter_module, 'Newsletter' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@newsletter_user, admin_dashboard_path)
      sign_in @administrator
      assert_crud_actions(@newsletter_user, admin_dashboard_path)
      sign_in @subscriber
      assert_crud_actions(@newsletter_user, admin_dashboard_path)
    end

    private

    def initialize_test
      @newsletter_user = newsletter_users(:newsletter_user_fr)
      @newsletter_module = optional_modules(:newsletter)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
