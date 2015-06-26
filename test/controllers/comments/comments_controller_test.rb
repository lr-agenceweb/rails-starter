require 'test_helper'

#
# == CommentsController Test
#
class CommentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include Rails.application.routes.url_helpers

  setup :initialize_test

  #
  # == Create
  #
  test 'should not be able to create comment if no content' do
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        assert_no_difference 'Comment.count' do
          post :create, about_id: @about.id, comment: { comment: nil }, locale: locale.to_s
        end
        assert_not assigns(:comment).valid?
        assert_not assigns(:comment).save
      end
    end
  end

  test 'should not be able to create comment if nickname (captcha) is filled' do
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        assert_no_difference 'Comment.count' do
          post :create, about_id: @about.id, comment: { comment: 'youpi', nickname: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: locale.to_s }, locale: locale.to_s
        end
      end
    end
  end

  test 'should not be able to create comment if lang is not set' do
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        assert_no_difference 'Comment.count' do
          post :create, about_id: @about.id, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw' }, locale: locale.to_s
        end
        assert_not assigns(:comment).valid?
      end
    end
  end

  test 'should not be able to create comment if lang is not allowed' do
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        assert_no_difference 'Comment.count' do
          post :create, about_id: @about.id, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: 'ch' }, locale: locale.to_s
        end
        assert_not assigns(:comment).valid?
      end
    end
  end

  test 'should not be able to create comment if email is not valid' do
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        assert_no_difference 'Comment.count' do
          post :create, about_id: @about.id, comment: { comment: 'youpi', nickname: '', username: 'leila', email: 'not_valid', lang: locale.to_s }, locale: locale.to_s
        end
        assert_not assigns(:comment).valid?
      end
    end
  end

  test 'should create comment with more informations if not connected' do
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        assert_difference 'Comment.count' do
          post :create, about_id: @about.id, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: locale.to_s }, locale: locale.to_s
        end
        assert assigns(:comment).valid?
        assert_redirected_to @about
      end
    end
  end

  test 'should have informations of user given if not connected' do
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        post :create, about_id: @about.id, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: locale.to_s }, locale: locale.to_s
        assert_nil assigns(:comment).user_id
        assert_equal assigns(:comment).username, 'leila'
        assert_equal assigns(:comment).email, 'leila@skywalker.sw'
        assert_equal assigns(:comment).lang, locale.to_s
      end
    end
  end

  test 'should create comment only with comment field if connected' do
    sign_in @lana
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        assert_difference 'Comment.count' do
          post :create, about_id: @about.id, comment: { comment: 'youpi', lang: locale.to_s }, locale: locale.to_s
        end
        assert assigns(:comment).valid?
        assert_redirected_to @about
      end
    end
  end

  test 'should have informations of sign_in user if connected' do
    sign_in @lana
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        post :create, about_id: @about.id, comment: { comment: 'youpi', lang: locale.to_s }, locale: locale.to_s
        assert assigns(:comment).valid?
        assert_nil assigns(:comment).username
        assert_nil assigns(:comment).email
        assert_equal assigns(:comment).user_id, @lana.id
      end
    end
  end

  #
  # == Ajax
  #
  test 'AJAX :: should create comment' do
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        xhr :post, :create, format: :js, about_id: @about.id, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: locale.to_s }, locale: locale.to_s
        assert_response :success
      end
    end
  end

  test 'AJAX :: should render show template if comment created' do
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        xhr :post, :create, format: :js, about_id: @about.id, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: locale.to_s }, locale: locale.to_s
        assert_template :create
      end
    end
  end

  test 'AJAX :: should not create comment if nickname is filled' do
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        xhr :post, :create, format: :js, about_id: @about.id, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw', nickname: 'robot', lang: locale.to_s }, locale: locale.to_s
        assert_template :captcha
      end
    end
  end

  #
  # == Destroy
  #
  test 'should not be able to delete comments if user is not logged in' do
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        assert_no_difference 'Comment.count' do
          delete :destroy, id: @comment_alice.id, about_id: @about.id, locale: locale.to_s
        end
      end
    end
  end

  test 'should be able to delete every comments if user is superadministrator' do
    if @locales.include?(:fr)
      sign_in @super_administrator
      locale = 'fr'
      I18n.with_locale(locale) do
        assert_difference 'Comment.count', -1 do
          delete :destroy, id: @comment_alice.id, about_id: @about.id, locale: locale
        end
      end
    end
  end

  test 'subscriber should not be able to delete comments except his own' do
    sign_in @lana
    locale = 'fr'
    I18n.with_locale(locale) do
      assert_difference 'Comment.count', -1 do
        delete :destroy, id: @comment_lana.id, about_id: @about.id, locale: locale
      end

      assert_no_difference 'Comment.count' do
        delete :destroy, id: @comment_alice.id, about_id: @about.id, locale: locale
      end
    end
  end

  test 'administrator should be able to delete comments except superadministrator' do
    sign_in @administrator
    ability = Ability.new(@administrator)
    locale = 'fr'

    I18n.with_locale(locale) do
      assert ability.can?(:destroy, @comment_lana)
      assert_difference 'Comment.count', -1 do
        delete :destroy, id: @comment_lana.id, about_id: @about.id, locale: locale
      end

      assert ability.cannot?(:destroy, @comment_anthony)
      assert_no_difference 'Comment.count' do
        delete :destroy, id: @comment_anthony.id, about_id: @about.id, locale: locale
      end
    end
  end

  private

  def initialize_test
    @locales = I18n.available_locales
    @about = posts(:about)

    @super_administrator = users(:anthony)
    @administrator = users(:bob)
    @lana = users(:lana)

    @comment_anthony = comments(:one)
    @comment_bob = comments(:two)
    @comment_alice = comments(:three)
    @comment_lana = comments(:four)
    @comment_luke = comments(:five)
  end
end
