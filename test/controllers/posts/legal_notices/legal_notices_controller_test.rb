require 'test_helper'

#
# == LegalNoticesController Test
#
class LegalNoticesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include Rails.application.routes.url_helpers

  setup :initialize_test

  #
  # == Routes / Templates / Responses
  #
  test 'should get index' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :index, locale: locale.to_s
        assert_response :success
        assert_not_nil assigns(:legal_notices)
      end
    end
  end

  test 'should use index template' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :index, locale: locale.to_s
        assert_template :index
      end
    end
  end

  test 'should get index page targetting legal_notices controller' do
    assert_routing '/mentions-legales', controller: 'legal_notices', action: 'index', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/legal-notices', controller: 'legal_notices', action: 'index', locale: 'en' if @locales.include?(:en)
  end

  #
  # == Menu offline
  #
  test 'should render 404 if menu item is offline' do
    @menu.update_attribute(:online, false)
    assert_not @menu.online, 'menu item should be offline'

    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_raises(ActionController::RoutingError) do
          get :index, locale: locale.to_s
        end
      end
    end
  end

  private

  def initialize_test
    @locales = I18n.available_locales
    @setting = settings(:one)
    @menu = menus(:legal_notice)

    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)
  end
end
