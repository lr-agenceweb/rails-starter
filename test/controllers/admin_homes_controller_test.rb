require 'test_helper'

# Admin::HomesControllerTest file
class Admin::HomesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup :initialize_settings

  test 'should redirect to users/sign_in if not logged in' do
    sign_out @anthony
    get :index
    assert_redirected_to new_user_session_path
    get :show, id: @home.id
    assert_redirected_to new_user_session_path
    get :edit, id: @home.id
    assert_redirected_to new_user_session_path
  end

  test 'should show index page if logged in' do
    get :index
    assert_response :success
  end

  test 'should show show page if logged in' do
    get :show, id: @home.id
    assert_response :success
  end

  test 'should show edit page if logged in' do
    get :edit, id: @home.id
    assert_response :success
  end

  test 'should update home if logged in' do
    patch :update, id: @home.id, home: {}
    assert_redirected_to admin_home_path(@home)
  end

  ### It's not possible to create or delete Home posts currently
  # test 'should destroy home' do
  #   assert_difference ['Home.count', 'Referencement.count'], -1 do
  #     delete :destroy, id: @home.id
  #   end
  #   assert_redirected_to admin_abouts_path
  # end

  private

  def initialize_settings
    @home = posts(:home)
    @anthony = users(:anthony)
    sign_in @anthony
  end
end
