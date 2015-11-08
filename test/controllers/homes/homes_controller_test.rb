require 'test_helper'

#
# == HomesController Test
#
class HomesControllerTest < ActionController::TestCase
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
        assert_not_nil assigns(:homes)
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

  test 'should fetch only online posts' do
    @homes = Home.online
    assert_equal @homes.length, 1
  end

  test 'should get hompepage targetting home controller' do
    assert_routing '/', controller: 'homes', action: 'index', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en', controller: 'homes', action: 'index', locale: 'en' if @locales.include?(:en)
  end

  #
  # == Easter egg
  #
  test 'should redirect to homepage if access easter_egg' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :easter_egg, locale: locale.to_s
        assert_redirected_to root_path(locale: locale)
      end
    end
  end

  test 'AJAX :: should render easter_egg' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        xhr :get, :easter_egg, locale: locale.to_s
        assert_response :success
        assert_template :easter_egg
      end
    end
  end

  test 'should get easter-egg page by url' do
    assert_routing '/accueil/easter-egg', controller: 'homes', action: 'easter_egg', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/home/easter-egg', controller: 'homes', action: 'easter_egg', locale: 'en' if @locales.include?(:en)
  end

  #
  # == Maintenance
  #
  test 'should render maintenance if enabled and not connected' do
    assert_maintenance
  end

  test 'should not render maintenance even if enabled and SA' do
    sign_in @super_administrator
    assert_no_maintenance
  end

  test 'should not render maintenance even if enabled and Admin' do
    sign_in @administrator
    assert_no_maintenance
  end

  test 'should render maintenance if enabled and subscriber' do
    sign_in @subscriber
    assert_maintenance
  end

  private

  def initialize_test
    @home = posts(:home)
    @locales = I18n.available_locales
    @setting = settings(:one)

    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)
  end
end
