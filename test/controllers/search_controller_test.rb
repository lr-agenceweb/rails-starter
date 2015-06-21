require 'test_helper'

#
# == SearchController Test
#
class SearchControllerTest < ActionController::TestCase
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

  test 'should get search page by url' do
    assert_routing '/rechercher', controller: 'search', action: 'index', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/search', controller: 'search', action: 'index', locale: 'en' if @locales.include?(:en)
  end

  test 'should return empty object if query is not set' do
    @locales.each do |locale|
      get :index, locale: locale.to_s
      assert_empty assigns(:posts)
    end
  end

  test 'should return empty object if query is empty' do
    @locales.each do |locale|
      get :index, locale: locale.to_s, query: ''
      assert_empty assigns(:posts)
    end
  end

  test 'should return empty object if query not in post articles' do
    @locales.each do |locale|
      get :index, locale: locale.to_s, query: 'Unitary tests'
      assert_empty assigns(:posts)
    end
  end

  test 'should return full object if query in post articles' do
    query = 'Ruby'
    @locales.each do |locale|
      get :index, locale: locale.to_s, query: query
      posts = assigns(:posts)
      assert_not_empty posts
      assert_match(/#{query}/, posts.first.title)
      assert_match(/#{query}/, posts.first.content)
    end
  end

  test 'should not take care of offline post in search results' do
    query = 'Ruby'
    @locales.each do |locale|
      get :index, locale: locale.to_s, query: query
      posts = assigns(:posts)
      assert_equal posts.count, 1
    end
  end

  test 'should return different result by locale' do
    query = 'Hébergement'
    I18n.with_locale(:fr) do
      get :index, locale: 'fr', query: query
      posts = assigns(:posts)
      assert_not_empty posts
      assert_match(/#{query}/, posts.first.title)
    end

    if @locales.include?(:en)
      I18n.with_locale(:en) do
        get :index, locale: 'en', query: query
        assert_empty assigns(:posts)
      end
    end
  end

  # == Ajax
  test 'should execute query in ajax' do
    query = 'Ruby'
    xhr :get, :index, format: :js, query: query, locale: 'fr'
    assert_response :success
  end

  test 'should not be empty in ajax' do
    query = 'Hébergement'
    xhr :get, :index, format: :js, query: query, locale: 'fr'
    assert_not_empty assigns(:posts)
    assert assigns(:posts).count, 1
  end

  def initialize_test
    @locales = I18n.available_locales
    @category = categories(:search)
  end
end
