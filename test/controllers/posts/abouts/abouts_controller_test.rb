# frozen_string_literal: true
require 'test_helper'

#
# == AboutsController Test
#
class AboutsControllerTest < ActionController::TestCase
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
        assert_not_nil assigns(:abouts)
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

  test 'should get abouts page by url' do
    assert_routing '/a-propos', controller: 'abouts', action: 'index', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/about', controller: 'abouts', action: 'index', locale: 'en' if @locales.include?(:en)
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
  # == Translations
  #
  test 'should get show page with all locales' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, locale: locale.to_s, id: @about
        assert_response :success
        assert_not_nil @about
      end
    end
  end

  test 'assert integrity of request for each locales' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, locale: locale.to_s, id: @about
        assert_equal request.path_parameters[:id], @about.slug
        assert_equal request.path_parameters[:locale], locale.to_s
      end
    end
  end

  #
  # == Object
  #
  test 'should fetch only online posts' do
    @abouts = About.online
    assert_equal 1, @abouts.length
  end

  test 'should render 404 if about article is offline' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_raises(ActiveRecord::RecordNotFound) do
          get :show, locale: locale.to_s, id: @about_offline
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
    @about = posts(:about)
    @about_offline = posts(:about_offline)

    @locales = I18n.available_locales
    @setting = settings(:one)
    @menu = menus(:about)

    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)
  end
end
