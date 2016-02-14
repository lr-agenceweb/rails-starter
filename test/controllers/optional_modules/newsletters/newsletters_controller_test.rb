
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
  test 'should render preview_in_browser template and newsletter layout' do
    locale = @newsletter_user.lang
    I18n.with_locale(locale) do
      get :preview_in_browser, locale: locale.to_s, id: @newsletter, newsletter_user_id: @newsletter_user.id, token: @newsletter_user.token
      assert_response :success
      assert_template 'newsletter_mailer/send_newsletter', layout: 'newsletter'
    end
  end

  test 'should render 404 if newsletter have not already been sent' do
    locale = @newsletter_user.lang
    assert_raises(ActionController::RoutingError) do
      I18n.with_locale(locale) do
        get :preview_in_browser, locale: locale.to_s, id: @newsletter_not_sent, newsletter_user_id: @newsletter_user.id, token: @newsletter_user.token
      end
    end
  end

  test 'should render 404 if token don\'t match for preview_in_browser' do
    locale = @newsletter_user.lang
    assert_raises(ActionController::RoutingError) do
      I18n.with_locale(locale) do
        get :preview_in_browser, locale: locale.to_s, id: @newsletter_not_sent, newsletter_user_id: @newsletter_user.id, token: @newsletter_user_en.token
      end
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
      assert_template 'newsletter_mailer/welcome_user', layout: 'newsletter'
    end
  end

  test 'should render 404 if token don\'t match for welcome_user' do
    locale = @newsletter_user.lang
    assert_raises(ActionController::RoutingError) do
      I18n.with_locale(locale) do
        get :welcome_user, locale: locale.to_s, id: @newsletter_not_sent, newsletter_user_id: @newsletter_user.id, token: @newsletter_user_en.token
      end
    end
  end

  #
  # == Abilities
  #
  test 'should test abilities for subscriber' do
    sign_in @subscriber
    ability = Ability.new(@subscriber)
    assert ability.can?(:preview_in_browser, @newsletter), 'should be able to preview_in_browser'
    assert ability.can?(:welcome_user, @newsletter), 'should be able to see welcome_user'

    @newsletter_module.update_attribute(:enabled, false)
    ability = Ability.new(@subscriber)
    assert ability.cannot?(:preview_in_browser, @newsletter), 'should not be able to preview_in_browser'
    assert ability.cannot?(:welcome_user, @newsletter), 'should not be able to see welcome_user'
  end

  test 'should test abilities for administrator' do
    sign_in @administrator
    ability = Ability.new(@administrator)
    assert ability.can?(:preview_in_browser, @newsletter), 'should be able to preview_in_browser'
    assert ability.can?(:welcome_user, @newsletter), 'should be able to see welcome_user'

    @newsletter_module.update_attribute(:enabled, false)
    ability = Ability.new(@administrator)
    assert ability.cannot?(:preview_in_browser, @newsletter), 'should not be able to preview_in_browser'
    assert ability.cannot?(:welcome_user, @newsletter), 'should not be able to see welcome_user'
  end

  test 'should test abilities for super_administrator' do
    sign_in @super_administrator
    ability = Ability.new(@super_administrator)
    assert ability.can?(:preview_in_browser, @newsletter), 'should be able to preview_in_browser'
    assert ability.can?(:welcome_user, @newsletter), 'should be able to see welcome_user'

    @newsletter_module.update_attribute(:enabled, false)
    ability = Ability.new(@super_administrator)
    assert ability.cannot?(:preview_in_browser, @newsletter), 'should not be able to preview_in_browser'
    assert ability.cannot?(:welcome_user, @newsletter), 'should not be able to see welcome_user'
  end

  #
  # == Module disabled
  #
  test 'should render 404 if module is disabled' do
    disable_optional_module @super_administrator, @newsletter_module, 'Newsletter' # in test_helper.rb
    assert_raises(ActionController::RoutingError) do
      @locales.each do |locale|
        I18n.with_locale(locale.to_s) do
          get :welcome_user, locale: locale.to_s, id: @newsletter, newsletter_user_id: @newsletter_user.id, token: @newsletter_user.token
        end
      end
    end

    assert_raises(ActionController::RoutingError) do
      @locales.each do |locale|
        I18n.with_locale(locale.to_s) do
          get :preview_in_browser, locale: locale.to_s, id: @newsletter_not_sent, newsletter_user_id: @newsletter_user.id, token: @newsletter_user_en.token
        end
      end
    end
  end

  private

  def initialize_test
    @locales = I18n.available_locales
    @newsletter_module = optional_modules(:newsletter)

    @newsletter = newsletters(:one)
    @newsletter_not_sent = newsletters(:not_sent)

    @newsletter_user = newsletter_users(:newsletter_user_fr)
    @newsletter_user_en = newsletter_users(:newsletter_user_en)

    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)
  end
end
