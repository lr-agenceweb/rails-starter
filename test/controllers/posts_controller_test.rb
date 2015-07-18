require 'test_helper'

#
# == PostsController Test
#
class PostsControllerTest < ActionController::TestCase
  setup :initialize_test

  test 'should get atom page' do
    @locales.each do |locale|
      get :feed, format: :atom, locale: locale.to_s
      assert_response :success
    end
  end

  test 'should use feed template' do
    @locales.each do |locale|
      get :feed, format: :atom, locale: locale.to_s
      assert_template :feed
    end
  end

  test 'should target controller and action for feed url' do
    assert_routing '/feed.atom', controller: 'posts', action: 'feed', locale: 'fr', format: 'atom' if @locales.include?(:fr)
    assert_routing '/en/feed.atom', controller: 'posts', action: 'feed', locale: 'en', format: 'atom' if @locales.include?(:en)
  end

  test 'should redirect to french atom version if access to french rss' do
    get :feed, format: :rss, locale: 'fr'
    assert_redirected_to action: :feed, format: :atom, locale: 'fr'
  end

  if I18n.available_locales.include?(:en)
    test 'should redirect to english atom version if access to english rss' do
      get :feed, format: :rss, locale: 'en'
      assert_redirected_to action: :feed, format: :atom, locale: 'en'
    end
  end

  private

  def initialize_test
    @locales = I18n.available_locales
  end
end
