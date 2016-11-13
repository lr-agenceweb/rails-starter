# frozen_string_literal: true
require 'test_helper'

#
# == EventsController Test
#
class EventsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  include Rails.application.routes.url_helpers

  setup :initialize_test

  #
  # == Routes / Templates / Responses
  #
  test 'should get index' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :index, params: { locale: locale.to_s }
        assert_response :success
        assert_not_nil assigns(:events)
      end
    end
  end

  test 'should use index template' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :index, params: { locale: locale.to_s }
        assert_template :index
      end
    end
  end

  # FIXME: Fix this when FriendlyIdGlobalize will be fixed
  test 'should get show page with all locales' do
    skip 'Fix this when FriendlyIdGlobalize will be fixed'
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, params: { locale: locale.to_s, id: @event }
        assert_response :success
      end
    end
  end

  test 'assert integrity of request for each locales' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, params: { locale: locale.to_s, id: @event }
        assert_equal request.path_parameters[:id], @event.slug
        assert_equal request.path_parameters[:locale], locale.to_s
      end
    end
  end

  test 'should get index page targetting events controller' do
    assert_routing '/evenements', controller: 'events', action: 'index', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/events', controller: 'events', action: 'index', locale: 'en' if @locales.include?(:en)
  end

  #
  # == Object
  #
  test 'should render 404 if event article is offline' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_raises(ActiveRecord::RecordNotFound) do
          get :show, params: { locale: locale.to_s, id: @event_offline }
        end
      end
    end
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
          get :index, params: { locale: locale.to_s }
        end
      end
    end
  end

  #
  # == Module disabled
  #
  test 'should render 404 if module is disabled' do
    disable_optional_module @super_administrator, @event_module, 'Event' # in test_helper.rb
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_raises(ActionController::RoutingError) do
          get :index, params: { locale: locale.to_s }
        end
      end
    end
  end

  test 'should render filled json array if calendar module is enabled' do
    @event_setting.update_attribute(:show_calendar, true)
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, params: { locale: locale.to_s, format: :json }
        assert_response :success
        assert_not assigns(:calendar_events).blank?
      end
    end
  end

  test 'should render empty json array if calendar module is disabled' do
    @event_setting.update_attribute(:show_calendar, true)
    disable_optional_module @super_administrator, @calendar_module, 'Calendar' # in test_helper.rb
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, params: { locale: locale.to_s, format: :json }
        assert_response :success
        assert assigns(:calendar_events).blank?
      end
    end
  end

  #
  # == Maintenance
  #
  test 'should render maintenance if enabled and not connected' do
    assert_maintenance_frontend
  end

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

  private

  def initialize_test
    @event = events(:event_online)
    @event_offline = events(:event_offline)
    @event_setting = event_settings(:one)

    @event_module = optional_modules(:event)
    @calendar_module = optional_modules(:calendar)

    @locales = I18n.available_locales
    @setting = settings(:one)
    @menu = menus(:event)

    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)
  end
end
