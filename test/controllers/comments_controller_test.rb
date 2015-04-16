require 'test_helper'

#
# == CommentsController Test
#
class CommentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup :initialize_test

  test 'should not be able to create comment if no content' do
    assert_difference 'Comment.count', 0 do
      post :create, about_id: @about.id, comment: { comment: nil }
    end
    assert_not assigns(:comment).save
  end

  test 'should not be able to create comment if nickname (captcha) is filled' do
    assert_difference 'Comment.count', 0 do
      post :create, about_id: @about.id, comment: { comment: 'youpi', nickname: 'youpi', username: 'leila', email: 'leila@skywalker.sw' }
    end
  end

  test 'should create comment with more informations if not connected' do
    assert_difference 'Comment.count' do
      post :create, about_id: @about.id, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw' }
    end
    assert_redirected_to @about
  end

  test 'should have informations of user given if not connected' do
    post :create, about_id: @about.id, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw' }
    assert_nil assigns(:comment).user_id
    assert_equal assigns(:comment).username, 'leila'
    assert_equal assigns(:comment).email, 'leila@skywalker.sw'
  end

  test 'should create comment only with comment field if connected' do
    sign_in @lana
    assert_difference 'Comment.count' do
      post :create, about_id: @about.id, comment: { comment: 'youpi' }
    end
    assert_redirected_to @about
  end

  test 'should have informations of sign_in user if connected' do
    sign_in @lana
    post :create, about_id: @about.id, comment: { comment: 'youpi' }
    assert_nil assigns(:comment).username
    assert_nil assigns(:comment).email
    assert_equal assigns(:comment).user_id, @lana.id
  end

  private

  def initialize_test
    @about = posts(:about)
    @lana = users(:lana)
  end
end
