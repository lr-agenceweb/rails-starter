require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == HomesController test
  #
  class HomesControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      get :index
      assert_redirected_to new_user_session_path
      get :show, id: @home
      assert_redirected_to new_user_session_path
      get :edit, id: @home
      assert_redirected_to new_user_session_path
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should show show page if logged in' do
      get :show, id: @home
      assert_response :success
    end

    test 'should show edit page if logged in' do
      get :edit, id: @home
      assert_response :success
    end

    test 'should update home if logged in' do
      patch :update, id: @home, home: {}
      assert_redirected_to admin_home_path(@home)
    end

    test 'should destroy home' do
      assert_difference ['Home.count', 'Referencement.count'], -1 do
        delete :destroy, id: @home
      end
      assert_redirected_to admin_homes_path
    end

    private

    def initialize_test
      @home = posts(:home)

      @administrator = users(:bob)
      sign_in @administrator
    end
  end
end
