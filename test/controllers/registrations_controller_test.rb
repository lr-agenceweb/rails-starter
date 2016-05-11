# frozen_string_literal: true
require 'test_helper'

#
# == RegistrationsController Test
#
class RegistrationsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup :initialize_test

  test 'should register user' do
    skip 'Find a way to test user registration'
    email = Faker::Internet.free_email
    username = Faker::Internet.user_name
    post :create, user: { email: email, username: username }
    assert_equal username, assigns(:user).username
    assert_not assigns(:user).account_active?
    assert_not @controller.current_user
  end

  test 'should redirect to specific page with correct flash notice after signing_up' do
    skip 'Find a way to test sign_up redirection path and flash'
    post :create, user: { email: 'demo@demo.com', username: 'demo' }
    resp = @controller.after_sign_up_path_for(assigns(:user))
    assert_equal 'http://test.host/', resp
    assert_equal I18n.t('user.registration.not_activated'), flash[:notice]
  end

  def initialize_test
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end
end
