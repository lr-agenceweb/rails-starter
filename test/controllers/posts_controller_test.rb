require 'test_helper'

#
# == PostsController Test
#
class PostsControllerTest < ActionController::TestCase
  setup :initialize_test

  test 'should get atom page' do
    I18n.available_locales.each do |locale|
      get :feed, format: :atom, locale: locale.to_s
      assert_response :success
    end
  end

  test 'should use feed template' do
    get :feed, format: :atom, locale: 'fr'
    assert_template :feed
  end

  test 'should target controller and action for feed url' do
    assert_routing '/feed.atom', controller: 'posts', action: 'feed', locale: 'fr', format: 'atom'
    assert_routing '/en/feed.atom', controller: 'posts', action: 'feed', locale: 'en', format: 'atom'
  end

  test 'should redirect to french atom version if access to french rss' do
    get :feed, format: :rss, locale: 'fr'
    assert_redirected_to action: :feed, format: :atom, locale: 'fr'
  end

  test 'should redirect to english atom version if access to english rss' do
    get :feed, format: :rss, locale: 'en'
    assert_redirected_to action: :feed, format: :atom, locale: 'en'
  end

  private

  def initialize_test
  end
end
