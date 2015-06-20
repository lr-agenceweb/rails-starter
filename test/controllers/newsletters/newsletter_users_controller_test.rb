require 'test_helper'

#
# == NewsletterUsersController Test
#
class NewsletterUsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include Rails.application.routes.url_helpers

  setup :initialize_test

  #
  # == Subscribing
  #
  test 'should not create newsletter user if email not properly formatted' do
    assert_difference ['NewsletterUser.count'], 0 do
      post :create, newsletter_user: { email: 'aaabbb.cc', lang: 'fr' }
    end
  end

  test 'should not create newsletter user if lang is empty' do
    assert_difference ['NewsletterUser.count'], 0 do
      post :create, newsletter_user: { email: @email, lang: '' }
    end
  end

  test 'should not create newsletter user if lang is not allowed' do
    assert_difference ['NewsletterUser.count'], 0 do
      post :create, newsletter_user: { email: @email, lang: 'de' }
    end
  end

  test 'should create newsletter user' do
    assert_difference ['NewsletterUser.count'], 1 do
      post :create, newsletter_user: { email: @email, lang: @lang }
    end
  end

  test 'should get correct information after success save' do
    post :create, newsletter_user: { email: @email, lang: @lang }
    newsletter_user = assigns(:newsletter_user)

    assert_equal newsletter_user.email, @email
    assert_equal newsletter_user.lang, @lang
    assert_equal newsletter_user.role, 'subscriber'
  end

  #
  # == Unsubscribing
  #
  test 'should get redirected to french homepage after unsubscribing' do
    delete :unsubscribe, locale: 'fr', newsletter_user_id: @newsletter_user.id, token: @newsletter_user.token
    assert_redirected_to root_path(locale: 'fr')
  end

  test 'should get redirected to english homepage after unsubscribing' do
    delete :unsubscribe, locale: 'fr', newsletter_user_id: @newsletter_user_en.id, token: @newsletter_user_en.token
    assert_redirected_to root_path(locale: 'en')
  end

  test 'should unsubscribe newsletter user if token is correct' do
    assert_difference ['NewsletterUser.count'], -1 do
      delete :unsubscribe, locale: 'fr', newsletter_user_id: @newsletter_user.id, token: @newsletter_user.token
    end
  end

  test 'should not unsubscribe newsletter user if token is wrong' do
    assert_difference ['NewsletterUser.count'], 0 do
      delete :unsubscribe, locale: 'fr', newsletter_user_id: @newsletter_user.id, token: "#{@newsletter_user.token}-abc"
    end
  end

  private

  def initialize_test
    @locales = I18n.available_locales
    @request.env['HTTP_REFERER'] = root_url
    @newsletter_user = newsletter_users(:newsletter_user_fr)
    @newsletter_user_en = newsletter_users(:newsletter_user_en)

    @email = 'aaa@bbb.cc'
    @lang = 'fr'
  end
end
