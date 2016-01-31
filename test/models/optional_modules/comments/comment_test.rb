require 'test_helper'

#
# == Comment test
#
class CommentTest < ActiveSupport::TestCase
  setup :initialize_test

  #
  # == Validation
  #
  test 'should not be able to create if all good' do
    comment = Comment.new(comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: 'fr')
    assert comment.valid?
    assert comment.errors.keys.empty?
  end

  test 'should not be able to create if empty' do
    comment = Comment.new
    assert_not comment.valid?
    assert_equal [:comment, :lang], comment.errors.keys
  end

  # Robots thinks it's valid but nothing is created by controller
  test 'should not be able to create if captcha filled' do
    comment = Comment.new(comment: 'youpi', nickname: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: 'fr')
    assert comment.valid?
    assert comment.errors.keys.empty?
  end

  test 'should not be able to create if lang is not allowed' do
    comment = Comment.new(comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: 'zh')
    assert_not comment.valid?
    assert_equal [:lang], comment.errors.keys
  end

  test 'should not be able to create if email is not valid' do
    comment = Comment.new(comment: 'youpi', username: 'leila', email: 'fakemail', lang: 'fr')
    assert_not comment.valid?
    assert_equal [:email], comment.errors.keys
  end

  #
  # == Ancestry
  #
  test 'should have correct child and parent for comment' do
    @comment_bob.update_attribute(:parent_id, @comment_anthony.id)
    assert_equal @comment_anthony.id, @comment_bob.parent_id
    assert_equal 1, @comment_anthony.children.length
  end

  private

  def initialize_test
    @about = posts(:about_2)

    @comment_anthony = comments(:one)
    @comment_bob = comments(:two)
  end
end
