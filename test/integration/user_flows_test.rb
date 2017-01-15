# frozen_string_literal: true
require 'test_helper'

#
# UserFlowsTest
# ===============
class UserFlowsTest < ActionDispatch::IntegrationTest
  test 'should sign in user with email as login' do
    sign_in_user_for_test
    assert_equal 200, status
    assert_equal admin_root_path, path
    assert_equal I18n.t('devise.sessions.signed_in'), flash[:notice]

    sign_out_user_for_test
  end

  test 'should sign in user with username as login' do
    sign_in_user_for_test(method: :username)
    assert_equal 200, status
    assert_equal admin_root_path, path
    assert_equal I18n.t('devise.sessions.signed_in'), flash[:notice]

    sign_out_user_for_test
  end

  test 'signed out user is redirected to admin login' do
    sign_in_user_for_test
    sign_out_user_for_test

    assert_equal 200, status
    assert_equal new_user_session_path, path
    assert_equal I18n.t('devise.sessions.signed_out'), flash[:notice]
  end

  private

  def sign_in_user_for_test(method: :email)
    admin = users(:bob)

    get new_user_session_path
    assert_equal 200, status

    post user_session_path, params: {
      user: { login: admin.send(method.to_s), password: 'password' }
    }
    follow_redirect!
  end

  def sign_out_user_for_test
    delete destroy_user_session_path
    follow_redirect!
  end
end
