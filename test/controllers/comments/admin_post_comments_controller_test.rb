require 'test_helper'

#
# == Admin namespace
#
module Admin
  #
  # == PostCommentsController test
  #
  class PostCommentsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup :initialize_test

    test 'should redirect to users/sign_in if not logged in' do
      sign_out @anthony
      get :index
      assert_redirected_to new_user_session_path
      get :show, id: @comment.id
      assert_redirected_to new_user_session_path
      delete :destroy, id: @comment.id
      assert_redirected_to new_user_session_path
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should show show page if logged in' do
      get :show, id: @comment.id
      assert_response :success
    end

    test 'should not be able to show comments for other users' do
      sign_in @alice
      get :show, id: @comment.id
      assert_redirected_to admin_dashboard_path
    end

    test 'should not be able to destroy administrator comments if subscriber' do
      sign_in @alice
      assert_no_difference ['Comment.count'] do
        delete :destroy, id: @comment.id
      end
      assert_redirected_to admin_dashboard_path
    end

    test 'should destroy own comment' do
      sign_in @alice
      assert_difference ['Comment.count'], -1 do
        delete :destroy, id: @comment_alice.id
      end
      assert_redirected_to admin_post_comments_path
    end

    test 'should destroy all comments if super_administrator' do
      assert_difference ['Comment.count'], -1 do
        delete :destroy, id: @comment_alice.id
      end
      assert_redirected_to admin_post_comments_path
    end

    private

    def initialize_test
      @anthony = users(:anthony)
      @alice = users(:alice)
      @comment = comments(:one)
      @comment_alice = comments(:three)
      sign_in @anthony
    end
  end
end
