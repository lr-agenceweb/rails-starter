require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == CategoriesController test
  #
  class NewsletterUsersControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    test 'should redirect to users/sign_in if not logged in' do
      sign_out @bob
      get :index
      assert_redirected_to new_user_session_path
      get :show, id: @newsletter_user.id
      assert_redirected_to new_user_session_path
      get :edit, id: @newsletter_user.id
      assert_redirected_to new_user_session_path
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should show show page if logged in' do
      get :show, id: @newsletter_user.id
      assert_response :success
    end

    test 'should show edit page if logged in' do
      get :edit, id: @newsletter_user.id
      assert_response :success
    end

    # Valid params
    test 'should update newsletter_user if logged in' do
      patch :update, id: @newsletter_user.id, newsletter_user: {}
      assert_redirected_to admin_newsletter_user_path(@newsletter_user)
    end

    test 'should update newsletter_user role' do
      patch :update, id: @newsletter_user.id, newsletter_user: { role: 'tester' }
      assert_equal 'tester', assigns(:newsletter_user).role
    end

    # Invalid params
    # TODO: Fix this test
    test 'should not update newsletter_user if lang params is not allowed' do
      patch :update, id: @newsletter_user.id, newsletter_user: { lang: 'de' }
      assert_equal @newsletter_user.lang, assigns(:newsletter_user).lang
    end

    # TODO: Fix this test
    test 'should not update newsletter_user role if role params not allowed' do
      patch :update, id: @newsletter_user.id, newsletter_user: { role: 'administrator' }
      assert_equal 'tester', assigns(:newsletter_user).role
    end

    test 'should not update newsletter_user if email params is changed' do
      patch :update, id: @newsletter_user.id, newsletter_user: { email: 'test@test.com' }
      assert_equal @newsletter_user.email, assigns(:newsletter_user).email
    end

    test 'should render edit template if lang is not allowed' do
      patch :update, id: @newsletter_user.id, newsletter_user: { lang: 'de' }
      assert_template :edit
    end

    test 'should render edit template if role is not allowed' do
      patch :update, id: @newsletter_user.id, newsletter_user: { role: 'administrator' }
      assert_template :edit
    end

    private

    def initialize_test
      @newsletter_user = newsletter_users(:newsletter_user_fr)
      @bob = users(:bob)
      sign_in @bob
    end
  end
end
