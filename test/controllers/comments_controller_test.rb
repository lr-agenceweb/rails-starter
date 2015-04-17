require 'test_helper'

#
# == CommentsController Test
#
class CommentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include Rails.application.routes.url_helpers

  setup :initialize_test

  test 'should not be able to create comment if no content' do
    assert_difference 'Comment.count', 0 do
      post :create, about_id: @about.id, comment: { comment: nil }, locale: 'fr'
    end
    assert_not assigns(:comment).save
  end

  test 'should not be able to create comment if nickname (captcha) is filled' do
    assert_difference 'Comment.count', 0 do
      post :create, about_id: @about.id, comment: { comment: 'youpi', nickname: 'youpi', username: 'leila', email: 'leila@skywalker.sw' }, locale: 'fr'
    end
  end

  test 'should create comment with more informations if not connected' do
    assert_difference 'Comment.count' do
      post :create, about_id: @about.id, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw' }, locale: 'fr'
    end
    assert_redirected_to @about
  end

  test 'should have informations of user given if not connected' do
    post :create, about_id: @about.id, comment: { comment: 'youpi', username: 'leila', email: 'leila@skywalker.sw' }, locale: 'fr'
    assert_nil assigns(:comment).user_id
    assert_equal assigns(:comment).username, 'leila'
    assert_equal assigns(:comment).email, 'leila@skywalker.sw'
  end

  test 'should create comment only with comment field if connected' do
    sign_in @lana
    assert_difference 'Comment.count' do
      post :create, about_id: @about.id, comment: { comment: 'youpi' }, locale: 'fr'
    end
    assert_redirected_to @about
  end

  test 'should have informations of sign_in user if connected' do
    sign_in @lana
    post :create, about_id: @about.id, comment: { comment: 'youpi' }, locale: 'fr'
    assert_nil assigns(:comment).username
    assert_nil assigns(:comment).email
    assert_equal assigns(:comment).user_id, @lana.id
  end

  #
  # == Destroy
  #
  test 'should not be able to delete comments if user is not logged in' do
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        assert_difference 'Comment.count', 0 do
          delete :destroy, id: @comment_alice.id, about_id: @about.id, locale: locale
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

      assert_difference 'Comment.count', 0 do
        delete :destroy, id: @comment_alice.id, about_id: @about.id, locale: locale
      end
    end
  end

  test 'administrator should be able to delete comments except superadministrator' do
    sign_in @administrator
    locale = 'fr'
    I18n.with_locale(locale) do
      assert_difference 'Comment.count', -1 do
        delete :destroy, id: @comment_lana.id, about_id: @about.id, locale: locale
      end

      assert_difference 'Comment.count', 0 do
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
