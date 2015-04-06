require 'test_helper'

# Admin::UsersControllerTest file
class Admin::UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup :initialize_settings

  test 'should redirect to users/sign_in if not logged in' do
    sign_out @anthony
    get :index
    assert_redirected_to new_user_session_path
    get :show, id: @bob.id
    assert_redirected_to new_user_session_path
    get :edit, id: @bob.id
    assert_redirected_to new_user_session_path
  end

  test 'should show index page if logged in' do
    get :index
    assert_response :success
  end

  test 'should show show page if logged in' do
    get :show, id: @bob.id
    assert_response :success
  end

  test 'should show edit page if logged in' do
    get :edit, id: @bob.id
    assert_response :success
  end

  test 'should update user if logged in' do
    patch :update, id: @bob.id, user: {}
    assert_redirected_to admin_user_path(@bob)
  end

  test 'should destroy user' do
    assert_difference 'User.count', -1 do
      delete :destroy, id: @bob.id
    end
    assert_redirected_to admin_users_path
  end

  test 'should count users' do
    @users = User.all
    assert_equal @users.length, 3
  end

  private

  def initialize_settings
    @bob = users(:bob)
    @anthony = users(:anthony)
    sign_in @anthony
  end
end
