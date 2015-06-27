require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == AboutsController test
  #
  class AboutsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    #
    # == REST actions
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @bob
      get :index
      assert_redirected_to new_user_session_path
      get :show, id: @about.id
      assert_redirected_to new_user_session_path
      get :edit, id: @about.id
      assert_redirected_to new_user_session_path
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should show show page if logged in' do
      get :show, id: @about.id
      assert_response :success
    end

    test 'should show edit page if logged in' do
      get :edit, id: @about.id
      assert_response :success
    end

    test 'should update about if logged in' do
      patch :update, id: @about.id, about: {}
      assert_redirected_to admin_about_path(@about)
    end

    test 'should destroy about' do
      assert_difference ['About.count', 'Referencement.count'], -1 do
        delete :destroy, id: @about.id
      end
      assert_redirected_to admin_abouts_path
    end

    #
    # == Comments
    #
    test 'should destroy comments with post' do
      delete :destroy, id: @about.id
      assert_equal 0, @about.comments.size
      assert @about.comments.empty?
    end

    private

    def initialize_test
      @about = posts(:about)
      @bob = users(:bob)
      sign_in @bob
    end
  end
end

# TODO: Add test for create
