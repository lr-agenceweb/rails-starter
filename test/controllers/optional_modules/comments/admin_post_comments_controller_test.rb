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
      sign_out @administrator
      get :index
      assert_redirected_to new_user_session_path
      get :show, id: @comment
      assert_redirected_to new_user_session_path
      delete :destroy, id: @comment
      assert_redirected_to new_user_session_path
    end

    test 'should show index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should show show page if logged in' do
      get :show, id: @comment
      assert_response :success
    end

    test 'should not be able to show comments for other users' do
      sign_in @subscriber
      get :show, id: @comment
      assert_redirected_to admin_dashboard_path
    end

    test 'should not be able to edit a comment' do
      get :edit, id: @comment_administrator
      assert_redirected_to admin_dashboard_path
    end

    test 'should not be able to destroy administrator comments if subscriber' do
      sign_in @subscriber
      assert_no_difference ['Comment.count'] do
        delete :destroy, id: @comment_administrator
      end
      assert_redirected_to admin_dashboard_path
    end

    test 'should not be able to destroy super_administrator comments if administrator' do
      assert_no_difference ['Comment.count'] do
        delete :destroy, id: @comment
      end
      assert_redirected_to admin_dashboard_path
    end

    test 'should destroy own comment' do
      sign_in @subscriber
      assert_difference ['Comment.count'], -1 do
        delete :destroy, id: @comment_subscriber
      end
      assert_redirected_to admin_post_comments_path
    end

    # TODO: Fix broken test
    # test 'should destroy all comments if super_administrator' do
    #   sign_in @super_administrator
    #   assert_difference ['Comment.count'], -3 do
    #     delete :destroy, id: @comment
    #     delete :destroy, id: @comment_subscriber
    #     delete :destroy, id: @comment_administrator
    #   end
    #   assert_redirected_to admin_post_comments_path
    # end

    private

    def initialize_test
      @comment = comments(:one)
      @comment_administrator = comments(:two)
      @comment_subscriber = comments(:three)

      @super_administrator = users(:anthony)
      @administrator = users(:bob)
      @subscriber = users(:alice)
      sign_in @administrator
    end
  end
end
