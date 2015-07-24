require 'test_helper'

#
# == EventsController Test
#
class EventsControllerTest < ActionController::TestCase
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
        assert_not_nil assigns(:events)
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

  test 'should get show page with all locales' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, locale: locale.to_s, id: @event
        assert_response :success
      end
    end
  end

  test 'assert integrity of request for each locales' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, locale: locale.to_s, id: @event
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
          get :show, locale: locale.to_s, id: @event_offline
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
          get :index, locale: locale.to_s
        end
      end
    end
  end

  private

  def initialize_test
    @locales = I18n.available_locales
    @event = events(:event_online)
    @event_offline = events(:event_offline)
    @event_module = optional_modules(:event)

    @super_administrator = users(:anthony)
  end
end
