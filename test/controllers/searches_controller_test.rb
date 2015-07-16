require 'test_helper'

#
# == SearchesController Test
#
class SearchesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup :initialize_test

  test 'should get index' do
    @locales.each do |locale|
      get :index, locale: locale.to_s
      assert_response :success
    end
  end

  test 'should use index template' do
    @locales.each do |locale|
      get :index, locale: locale.to_s
      assert_template :index
    end
  end

  test 'should have a background color associated' do
    @locales.each do |locale|
      get :index, locale: locale.to_s
      assert_equal assigns(:category).color, '#F00'
    end
  end

  test 'should get search page by url' do
    assert_routing '/rechercher', controller: 'searches', action: 'index', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/search', controller: 'searches', action: 'index', locale: 'en' if @locales.include?(:en)
  end

  test 'should return empty object if term is not set' do
    @locales.each do |locale|
      get :index, locale: locale.to_s
      assert_empty assigns(:searches)
    end
  end

  test 'should return empty object if term is empty' do
    @locales.each do |locale|
      get :index, locale: locale.to_s, term: ''
      assert_empty assigns(:searches)
    end
  end

  test 'should return empty object if term not in post articles' do
    @locales.each do |locale|
      get :index, locale: locale.to_s, term: 'Unitary tests'
      assert_empty assigns(:searches)
    end
  end

  test 'should return full object if term in post articles' do
    term = 'Ruby'
    @locales.each do |locale|
      get :index, locale: locale.to_s, term: term
      searches = assigns(:searches)
      assert_not_empty searches
      assert_match(/#{term}/, searches.first.title)
      assert_match(/#{term}/, searches.first.content)
    end
  end

  test 'should not take care of offline post in search results' do
    term = 'Ruby'
    @locales.each do |locale|
      get :index, locale: locale.to_s, term: term
      searches = assigns(:searches)
      assert_equal searches.count, 1
    end
  end

  test 'should return different result by locale' do
    term = 'Hébergement'
    I18n.with_locale(:fr) do
      get :index, locale: 'fr', term: term
      searches = assigns(:searches)
      assert_not_empty searches
      assert_match(/#{term}/, searches.first.title)
    end

    if @locales.include?(:en)
      I18n.with_locale(:en) do
        get :index, locale: 'en', term: term
        assert_empty assigns(:searches)
      end
    end
  end

  # == Ajax
  test 'should execute term in ajax' do
    term = 'Ruby'
    xhr :get, :index, format: :js, term: term, locale: 'fr'
    assert_response :success
  end

  test 'should not be empty in ajax' do
    term = 'Hébergement'
    xhr :get, :index, format: :js, term: term, locale: 'fr'
    assert_not_empty assigns(:searches)
    assert assigns(:searches).count, 1
  end

  private

  def initialize_test
    @locales = I18n.available_locales
    @category = categories(:search)
  end
end
