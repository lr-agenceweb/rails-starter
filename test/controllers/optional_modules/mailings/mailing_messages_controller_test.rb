require 'test_helper'

#
# == MailingMessagesController Test
#
class MailingMessagesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include Rails.application.routes.url_helpers

  setup :initialize_test

  #
  # == Preview in browser
  #
  test 'should render preview in browser template' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :preview_in_browser, locale: locale.to_s, id: @mailing_message.id, token: @mailing_message.token, mailing_user_id: @mailing_user.id, mailing_user_token: @mailing_user.token
        assert_template :send_email
        assert_template :send_email, layout: 'mailing'
      end
    end
  end

  #
  # == Request integrity
  #
  test 'should render 404 if tries to access another mailing' do
    assert_raises(ActionController::RoutingError) do
      @locales.each do |locale|
        I18n.with_locale(locale.to_s) do
          get :preview_in_browser, locale: locale.to_s, id: @mailing_message_two.id, token: @mailing_message.token, mailing_user_id: @mailing_user.id, mailing_user_token: @mailing_user.token
        end
      end
    end
  end

  test 'should render 404 if mailing_user token is not present' do
    assert_raises(ActionController::RoutingError) do
      @locales.each do |locale|
        I18n.with_locale(locale.to_s) do
          get :preview_in_browser, locale: locale.to_s, id: @mailing_message.id, token: @mailing_message.token, mailing_user_id: @mailing_user.id, mailing_user_token: ''
        end
      end
    end
  end

  test 'should render 404 if mailing_message token is not present' do
    assert_raises(ActionController::RoutingError) do
      @locales.each do |locale|
        I18n.with_locale(locale.to_s) do
          get :preview_in_browser, locale: locale.to_s, id: @mailing_message.id, token: '', mailing_user_id: @mailing_user.id, mailing_user_token: @mailing_user.token
        end
      end
    end
  end

  test 'should render 404 if mailing_message has not yet been sent' do
    assert_raises(ActionController::RoutingError) do
      @locales.each do |locale|
        I18n.with_locale(locale.to_s) do
          get :preview_in_browser, locale: locale.to_s, id: @mailing_message_two.id, token: @mailing_message_two.token, mailing_user_id: @mailing_user_two.id, mailing_user_token: @mailing_user_two.token
        end
      end
    end
  end

  test 'should render 404 if user is not subscribed to mailing' do
    assert_raises(ActionController::RoutingError) do
      @locales.each do |locale|
        I18n.with_locale(locale.to_s) do
          get :preview_in_browser, locale: locale.to_s, id: @mailing_message_three.id, token: @mailing_message_three.token, mailing_user_id: @mailing_user_two.id, mailing_user_token: @mailing_user_two.token
        end
      end
    end
  end

  #
  # == Module disabled
  #
  test 'should render 404 if module is disabled' do
    disable_optional_module @super_administrator, @mailing_module, 'Mailing' # in test_helper.rb
    assert_raises(ActionController::RoutingError) do
      @locales.each do |locale|
        I18n.with_locale(locale.to_s) do
          get :preview_in_browser, locale: locale.to_s, id: @mailing_message.id, token: @mailing_message.token, mailing_user_id: @mailing_user.id, mailing_user_token: @mailing_user.token
        end
      end
    end
  end

  private

  def initialize_test
    @setting = settings(:one)
    @locales = I18n.available_locales

    @mailing_user = mailing_users(:one)
    @mailing_user_two = mailing_users(:two)
    @mailing_user_three = mailing_users(:three)

    @mailing_message = mailing_messages(:one)
    @mailing_message_two = mailing_messages(:two)
    @mailing_message_three = mailing_messages(:three)

    @mailing_module = optional_modules(:mailing)

    @super_administrator = users(:anthony)
  end
end
