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

    #
    # == Routes / Templates / Responses
    #
    test 'should get index page if logged in' do
      get :index
      assert_response :success
    end

    test 'should get show page if logged in' do
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

    #
    # == Abilities
    #
    test 'should test abilities for subscriber' do
      sign_in @subscriber
      ability = Ability.new(@subscriber)
      assert ability.cannot?(:create, Comment.new), 'should not be able to create'
      assert ability.cannot?(:read, Comment.new), 'should not be able to read'
      assert ability.cannot?(:update, Comment.new), 'should not be able to update'
      assert ability.cannot?(:destroy, Comment.new), 'should not be able to destroy'
    end

    test 'should test abilities for administrator' do
      ability = Ability.new(@administrator)
      assert ability.cannot?(:create, Comment.new), 'should not be able to create'
      assert ability.can?(:read, Comment.new), 'should be able to read'
      assert ability.cannot?(:update, Comment.new), 'should not be able to update'
      assert ability.can?(:destroy, Comment.new), 'should be able to destroy'
    end

    test 'should test abilities for super_administrator' do
      sign_in @super_administrator
      ability = Ability.new(@super_administrator)
      assert ability.cannot?(:create, Comment.new), 'should not be able to create'
      assert ability.can?(:read, Comment.new), 'should be able to read'
      assert ability.cannot?(:update, Comment.new), 'should not be able to update'
      assert ability.can?(:destroy, Comment.new), 'should be able to destroy'
    end

    #
    # == Subscriber
    #
    test 'should redirect to users/sign_in if not logged in' do
      sign_out @administrator
      assert_crud_actions(@comment, new_user_session_path, model_name)
    end

    test 'should redirect to dashboard if subscriber' do
      sign_in @subscriber
      get :index
      assert_response :success
      assert_crud_actions(@comment, admin_dashboard_path, model_name, no_index: true)
    end

    test 'should destroy all comments if super_administrator' do
      skip 'Fix this broken test'
      sign_in @super_administrator
      assert_difference ['Comment.count'], -3 do
        delete :destroy, id: @comment
        delete :destroy, id: @comment_subscriber
        delete :destroy, id: @comment_administrator
      end
      assert_redirected_to admin_post_comments_path
    end

    #
    # == Module disabled
    #
    test 'should not access page if blog module is disabled' do
      disable_optional_module @super_administrator, @comment_module, 'Comment' # in test_helper.rb
      sign_in @super_administrator
      assert_crud_actions(@comment, admin_dashboard_path, model_name)
      sign_in @administrator
      assert_crud_actions(@comment, admin_dashboard_path, model_name)
      sign_in @subscriber
      assert_crud_actions(@comment, admin_dashboard_path, model_name)
    end

    private

    def initialize_test
      @comment = comments(:one)
      @comment_administrator = comments(:two)
      @comment_subscriber = comments(:three)
      @comment_module = optional_modules(:comment)

      @subscriber = users(:alice)
      @administrator = users(:bob)
      @super_administrator = users(:anthony)
      sign_in @administrator
    end
  end
end
