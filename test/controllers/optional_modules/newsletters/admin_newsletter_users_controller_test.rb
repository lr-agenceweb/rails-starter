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
      get :index
      assert_redirected_to new_user_session_path
      get :edit, id: @newsletter_user
      assert_redirected_to new_user_session_path
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
      assert !assigns(:newsletter_user).valid?
    end

    test 'should not update newsletter_user role if role params not allowed' do
      patch :update, id: @newsletter_user, newsletter_user: { role: 'administrator' }
      assert !assigns(:newsletter_user).valid?
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
      sign_out @administrator
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
    # == Module disabled
    #
    test 'should not access page if newsletter module is disabled' do
      disable_optional_module @super_administrator, @newsletter_module, 'Newsletter' # in test_helper.rb
      sign_in @administrator
      get :index
      assert_redirected_to admin_dashboard_path
    end

    private

    def initialize_test
      @administrator = users(:bob)
      @subscriber = users(:alice)
      @super_administrator = users(:anthony)
      @newsletter_user = newsletter_users(:newsletter_user_fr)
      @newsletter_module = optional_modules(:newsletter)

      sign_in @administrator
    end
  end
end
