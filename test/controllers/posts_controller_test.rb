require 'test_helper'

#
# == PostsController Test
#
class PostsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

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
      assert_template :feed, layout: false
    end
  end

  test 'should target controller and action for feed url' do
    assert_routing '/feed.atom', controller: 'posts', action: 'feed', locale: 'fr', format: 'atom' if @locales.include?(:fr)
    assert_routing '/en/feed.atom', controller: 'posts', action: 'feed', locale: 'en', format: 'atom' if @locales.include?(:en)
  end

  test 'should redirect to correct atom version by locale' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :feed, format: :rss, locale: locale.to_s
        assert_redirected_to action: :feed, format: :atom, locale: locale.to_s
      end
    end
  end

  test 'should render 404 if RSS module is diabled' do
    disable_optional_module @super_administrator, @rss_module, 'RSS' # in test_helper.rb
    sign_in @administrator
    @locales.each do |locale|
      assert_raises(ActionController::RoutingError) do
        get :feed, format: :atom, locale: locale.to_s
      end
    end
  end

  private

  def initialize_test
    @rss_module = optional_modules(:rss)

    @locales = I18n.available_locales
    @setting = settings(:one)

    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)
    sign_in @administrator
  end
end
