# frozen_string_literal: true
require 'test_helper'

#
# == UserFlowsTest
#
class UserFlowsTest < ActionDispatch::IntegrationTest
  test 'signed in user is redirected to admin path' do
    sign_in_user_for_test
    assert_equal I18n.t('devise.sessions.signed_in'), flash[:notice]
    assert_equal 302, status
    assert_equal '/admin', path
    follow_redirect!
    assert_equal 200, status
  end

  test 'signed out user is redirected to admin login' do
    sign_in_user_for_test
    sign_out_user_for_test
    assert_equal I18n.t('devise.sessions.signed_out'), flash[:notice]
    assert_equal 302, status
    follow_redirect!
    assert_equal 200, status
    assert_equal '/admin/login', path
  end

  private

  def sign_in_user_for_test
    get user_session_path
    assert_equal 200, status
    @user = User.create(email: 'user@example.com', username: 'user', password: Devise::Encryptor.digest(User, 'password'), account_active: true)
    post user_session_path, 'user[email]': @user.email, 'user[password]': @user.password
    follow_redirect!
  end

  def sign_out_user_for_test
    delete destroy_user_session_path
    follow_redirect!
  end
end
