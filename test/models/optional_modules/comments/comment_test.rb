# frozen_string_literal: true
require 'test_helper'

#
# Comment Model test
# ====================
class CommentTest < ActiveSupport::TestCase
  setup :initialize_test

  #
  # Shoulda
  # =========
  should belong_to(:commentable)
  should belong_to(:user)

  should_not validate_presence_of(:username)
  should_not validate_presence_of(:email)
  should validate_presence_of(:comment)
  should validate_presence_of(:lang)
  should validate_absence_of(:nickname)

  should allow_value('lorem@ipsum.com').for(:email)
  should_not allow_value('loremipsum.com').for(:email)

  should validate_inclusion_of(:lang)
    .in_array(I18n.available_locales.map(&:to_s))

  #
  # Validation rules
  # ==================
  test 'should be able to create if all good' do
    comment = Comment.new(comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: 'fr')
    assert comment.valid?
    assert comment.errors.keys.empty?
    assert_not comment.validated?, 'comment should not be validated'
  end

  test 'should not be able to create if empty' do
    comment = Comment.new
    assert_not comment.valid?
    assert_equal [:comment, :lang], comment.errors.keys
  end

  test 'should not be able to create if captcha filled' do
    comment = Comment.new(comment: 'youpi', nickname: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: 'fr')
    assert_not comment.valid?
    assert_equal [:nickname], comment.errors.keys
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

  test 'should have validated column to 1 if option disabled' do
    assert @comment_setting.should_validate?
    @comment_setting.update_attribute(:should_validate, false)
    assert_not @comment_setting.should_validate?

    comment = Comment.new(comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: 'fr')
    assert comment.valid?
    assert comment.errors.keys.empty?
    assert comment.validated?, 'comment should be automatically validated'
  end

  #
  # Ancestry
  # ==========
  test 'should have correct child and parent for comment' do
    @comment_bob.update_attribute(:parent_id, @comment_anthony.id)
    assert_equal @comment_anthony.id, @comment_bob.parent_id
    assert_equal 1, @comment_anthony.children.length
  end

  test 'should be able to reply if not max_depth' do
    comment = Comment.new(comment: 'youpi', username: 'leila', email: 'leila@skywalker.fr', lang: 'fr', parent_id: @comment_bob.id)
    assert comment.valid?
    assert comment.errors.keys.empty?
    assert comment.errors.messages.empty?
  end

  test 'should not be able to create reply if max_depth' do
    comment = Comment.new(comment: 'youpi', username: 'leila', email: 'leila@skywalker.fr', lang: 'fr', parent_id: @max_depth.id)
    assert_not comment.valid?
    assert_equal [:parent_id], comment.errors.keys
    assert_equal({ parent_id: [I18n.t('max_depth', scope: @i18n_scope)] }, comment.errors.messages)
  end

  test 'should return correct boolean value for max_depth?' do
    assert @max_depth.max_depth?
    assert_not @comment_bob.max_depth?
    assert_not @comment_anthony.max_depth?
  end

  test 'should return correct boolean value for strict_max_depth?' do
    assert @max_depth.max_depth?
    assert_not @comment_bob.max_depth?
    assert_not @comment_anthony.max_depth?
  end

  private

  def initialize_test
    @comment_anthony = comments(:one)
    @comment_bob = comments(:two)
    @max_depth = comments(:depth_2)

    @comment_setting = comment_settings(:one)
    @i18n_scope = 'activerecord.errors.models.comment.attributes'
  end
end
