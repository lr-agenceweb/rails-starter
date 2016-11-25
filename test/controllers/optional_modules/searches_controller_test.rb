# frozen_string_literal: true
require 'test_helper'

#
# == SearchesController Test
#
class SearchesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup :initialize_test

  #
  # Routes / Templates / Responses
  # =====================================
  # index
  test 'Index :: should get index' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, params: { locale: locale.to_s }
        assert_response :success
      end
    end
  end

  test 'Index :: should use index template' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, params: { locale: locale.to_s }
        assert_template :index
      end
    end
  end

  test 'Index :: should get search page by url' do
    assert_routing '/rechercher', controller: 'searches', action: 'index', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/search', controller: 'searches', action: 'index', locale: 'en' if @locales.include?(:en)
  end

  # autocomplete
  test 'Autocomplete :: should get autocomplete' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :autocomplete, params: { locale: locale.to_s }
        assert_response :success
      end
    end
  end

  test 'Autocomplete :: should use autocomplete template' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :autocomplete, params: { locale: locale.to_s }
        assert_template :index
      end
    end
  end

  test 'Autocomplete :: should get search page by url' do
    assert_routing '/rechercher/autocomplete', controller: 'searches', action: 'autocomplete', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/search/autocomplete', controller: 'searches', action: 'autocomplete', locale: 'en' if @locales.include?(:en)
  end

  #
  # Search params
  # ==================
  test 'should return empty object if term is not set' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, params: { locale: locale.to_s }
        assert_empty assigns(:searches)
      end
    end
  end

  test 'should return empty object if term is empty' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, params: { locale: locale.to_s, term: '' }
        assert_empty assigns(:searches)
      end
    end
  end

  test 'should return empty object if term not in post articles' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, params: { locale: locale.to_s, term: 'Unitary tests' }
        assert_empty assigns(:searches)
      end
    end
  end

  test 'should return full object if term in post articles' do
    term = 'Ruby'
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, params: { locale: locale.to_s, term: term }
        searches = assigns(:searches)
        assert_not_empty searches
        assert_match(/#{term}/, searches.first.title)
        assert_match(/#{term}/, searches.first.content)
      end
    end
  end

  test 'should not take care of offline post in search results' do
    term = 'Ruby'
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, params: { locale: locale.to_s, term: term }
        searches = assigns(:searches)
        assert_equal 1, searches.count
      end
    end
  end

  test 'should return different result by locale' do
    term = 'Hébergement'
    I18n.with_locale(:fr) do
      get :index, params: { locale: 'fr', term: term }
      searches = assigns(:searches)
      assert_not_empty searches
      assert_match(/#{term}/, searches.first.title)
    end

    if @locales.include?(:en)
      I18n.with_locale(:en) do
        get :index, params: { locale: 'en', term: term }
        assert_empty assigns(:searches)
      end
    end
  end

  #
  # Ajax
  # =======
  test 'AJAX :: should execute term in ajax' do
    term = 'Ruby'
    get :index, params: { format: :js, term: term, locale: 'fr' }, xhr: true
    assert_response :success
  end

  test 'AJAX :: should not be empty in ajax' do
    term = 'Hébergement'
    get :index, params: { format: :js, term: term, locale: 'fr' }, xhr: true
    assert_not_empty assigns(:searches)
    assert assigns(:searches).count, 1
  end

  #
  # JSON
  # =======
  # index
  test 'JSON/index :: should use index template and success response' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, params: { locale: locale.to_s, format: :json }
        assert_template :index
        assert_response :success
      end
    end
  end

  test 'JSON/index :: should return empty object if term is not set' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, params: { locale: locale.to_s, format: :json }
        assert_empty assigns(:searches)
      end
    end
  end

  test 'JSON/index :: should return empty object if term is empty' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, params: { locale: locale.to_s, format: :json, term: '' }
        assert_empty assigns(:searches)
      end
    end
  end

  test 'JSON/index :: should return empty object if term not in post articles' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, params: { locale: locale.to_s, format: :json, term: 'Unitary tests' }
        assert_empty assigns(:searches)
      end
    end
  end

  test 'JSON/index :: should return full object if term in post articles' do
    term = 'Ruby'
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, params: { locale: locale.to_s, format: :json, term: term }
        searches = assigns(:searches)
        assert_not_empty searches
        assert_match(/#{term}/, searches.first.title)
        assert_match(/#{term}/, searches.first.content)
      end
    end
  end

  test 'JSON/index :: should not take care of offline post in search results' do
    term = 'Ruby'
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, params: { locale: locale.to_s, format: :json, term: term }
        searches = assigns(:searches)
        assert_equal 1, searches.count
      end
    end
  end

  test 'JSON/index :: should return different result by locale' do
    term = 'Hébergement'
    I18n.with_locale(:fr) do
      get :index, params: { locale: 'fr', format: :json, term: term }
      searches = assigns(:searches)
      assert_not_empty searches
      assert_match(/#{term}/, searches.first.title)
    end

    if @locales.include?(:en)
      I18n.with_locale(:en) do
        get :index, params: { locale: 'en', format: :json, term: term }
        assert_empty assigns(:searches)
      end
    end
  end

  # autocomplete
  test 'JSON/autocomplete :: should use index template and success response' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :autocomplete, params: { locale: locale.to_s, format: :json }
        assert_template :index
        assert_response :success
      end
    end
  end

  test 'JSON/autocomplete :: should return empty object if term is not set' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :autocomplete, params: { locale: locale.to_s, format: :json }
        assert_empty assigns(:searches)
      end
    end
  end

  test 'JSON/autocomplete :: should return empty object if term is empty' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :autocomplete, params: { locale: locale.to_s, format: :json, term: '' }
        assert_empty assigns(:searches)
      end
    end
  end

  test 'JSON/autocomplete :: should return empty object if term not in post articles' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :autocomplete, params: { locale: locale.to_s, format: :json, term: 'Unitary tests' }
        assert_empty assigns(:searches)
      end
    end
  end

  test 'JSON/autocomplete :: should return full object if term in post articles' do
    term = 'Ruby'
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :autocomplete, params: { locale: locale.to_s, format: :json, term: term }
        searches = assigns(:searches)
        assert_not_empty searches
        assert_match(/#{term}/, searches.first.title)
        assert_match(/#{term}/, searches.first.content)
      end
    end
  end

  test 'JSON/autocomplete :: should not take care of offline post in search results' do
    term = 'Ruby'
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :autocomplete, params: { locale: locale.to_s, format: :json, term: term }
        searches = assigns(:searches)
        assert_equal 1, searches.count
      end
    end
  end

  test 'JSON/autocomplete :: should return different result by locale' do
    term = 'Hébergement'
    I18n.with_locale(:fr) do
      get :autocomplete, params: { locale: 'fr', format: :json, term: term }
      searches = assigns(:searches)
      assert_not_empty searches
      assert_match(/#{term}/, searches.first.title)
    end

    if @locales.include?(:en)
      I18n.with_locale(:en) do
        get :autocomplete, params: { locale: 'en', format: :json, term: term }
        assert_empty assigns(:searches)
      end
    end
  end

  #
  # Diverse
  # ==========
  test 'should have a background color associated' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, params: { locale: locale.to_s }
        assert_equal assigns(:page).color, '#F00'
      end
    end
  end

  #
  # Module disabled
  # ==================
  test 'should render 404 if module is disabled' do
    disable_optional_module @super_administrator, @search_module, 'Search' # in test_helper.rb
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_raises(ActionController::RoutingError) do
          get :index, params: { locale: locale.to_s }
        end
      end
    end
  end

  #
  # Menu offline
  # =================
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
  # Maintenance
  # ===============
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
    @locales = I18n.available_locales
    @setting = settings(:one)
    @menu = menus(:search)
    @search_module = optional_modules(:search)

    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)
  end
end
