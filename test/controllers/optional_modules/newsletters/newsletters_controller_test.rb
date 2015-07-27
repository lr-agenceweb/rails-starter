require 'test_helper'

#
# == NewslettersController Test
#
class NewslettersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include Rails.application.routes.url_helpers

  setup :initialize_test

  #
  # == See in browser [Newsletter]
  #
  test 'should render see_in_browser template and newsletter layout' do
    locale = @newsletter_user.lang
    I18n.with_locale(locale) do
      get :see_in_browser, locale: locale.to_s, id: @newsletter, newsletter_user_id: @newsletter_user.id, token: @newsletter_user.token
      assert_response :success
      assert_template :see_in_browser
      assert_template layout: :newsletter
    end
  end

  test 'should redirect to homepage if newsletter have not already been sent' do
    locale = @newsletter_user.lang
    I18n.with_locale(locale) do
      get :see_in_browser, locale: locale.to_s, id: @newsletter_not_sent, newsletter_user_id: @newsletter_user.id, token: @newsletter_user.token
      assert_redirected_to root_path(locale: locale)
    end
  end

  test 'should redirect to homepage if token not match newsletter user for see_in_browser' do
    locale = @newsletter_user.lang
    I18n.with_locale(locale) do
      get :see_in_browser, locale: locale.to_s, id: @newsletter_not_sent, newsletter_user_id: @newsletter_user.id, token: @newsletter_user_en.token
      assert_redirected_to root_path(locale: locale)
    end
  end

  #
  # == See in browser [Welcome User message]
  #
  test 'should render welcome_user template and newsletter layout' do
    locale = @newsletter_user.lang
    I18n.with_locale(locale) do
      get :welcome_user, locale: locale.to_s, id: @newsletter, newsletter_user_id: @newsletter_user.id, token: @newsletter_user.token
      assert_response :success
      assert_template :welcome_user
      assert_template layout: :newsletter
    end
  end

  test 'should redirect to homepage if token not match newsletter user for welcome_user' do
    locale = @newsletter_user.lang
    I18n.with_locale(locale) do
      get :welcome_user, locale: locale.to_s, id: @newsletter_not_sent, newsletter_user_id: @newsletter_user.id, token: @newsletter_user_en.token
      assert_redirected_to root_path(locale: locale)
    end
  end

  private

  def initialize_test
    @locales = I18n.available_locales
    @newsletter = newsletters(:one)
    @newsletter_not_sent = newsletters(:not_sent)
    @newsletter_user = newsletter_users(:newsletter_user_fr)
    @newsletter_user_en = newsletter_users(:newsletter_user_en)
  end
end