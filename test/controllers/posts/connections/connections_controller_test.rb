# frozen_string_literal: true
require 'test_helper'

#
# == ConnectionsController Test
#
class ConnectionsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
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
        assert_not_nil assigns(:connections)
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

  test 'should get connections page by url' do
    assert_routing '/liens', controller: 'connections', action: 'index', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/links', controller: 'connections', action: 'index', locale: 'en' if @locales.include?(:en)
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

  #
  # == Maintenance
  #
  test 'should not render maintenance even if enabled and SA' do
    sign_in @super_administrator
    assert_no_maintenance_frontend
  end

  test 'should not render maintenance even if enabled and Admin' do
    sign_in @administrator
    assert_no_maintenance_frontend
  end

  test 'should render maintenance if enabled and subscriber' do
    sign_in @subscriber
    assert_maintenance_frontend
  end

  test 'should render maintenance if enabled and not connected' do
    assert_maintenance_frontend
  end

  private

  def initialize_test
    @connection = posts(:connection)

    @locales = I18n.available_locales
    @menu = menus(:connection)
    @setting = settings(:one)

    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)
  end
end
