# frozen_string_literal: true
require 'test_helper'

#
# == PostsController Test
#
class PostsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  include Rails.application.routes.url_helpers

  setup :initialize_test

  #
  # == Global
  #
  test 'Global :: should get atom page' do
    @locales.each do |locale|
      get :feed, format: :atom, locale: locale.to_s
      assert_response :success
    end
  end

  test 'Global :: should use feed template' do
    @locales.each do |locale|
      get :feed, format: :atom, locale: locale.to_s
      assert_template :feed, layout: false
    end
  end

  test 'Global :: should target controller and action for feed url' do
    assert_routing '/feed.atom', controller: 'posts', action: 'feed', locale: 'fr', format: 'atom' if @locales.include?(:fr)
    assert_routing '/en/feed.atom', controller: 'posts', action: 'feed', locale: 'en', format: 'atom' if @locales.include?(:en)
  end

  test 'Global :: should redirect to correct atom version by locale' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :feed, format: :rss, locale: locale.to_s
        assert_redirected_to action: :feed, format: :atom, locale: locale.to_s
      end
    end
  end

  #
  # == Blogs
  #
  test 'Blog :: should get atom page' do
    @locales.each do |locale|
      get :blog, format: :atom, locale: locale.to_s
      assert_response :success
    end
  end

  test 'Blog :: should use feed template' do
    @locales.each do |locale|
      get :blog, format: :atom, locale: locale.to_s
      assert_template :feed, layout: false
    end
  end

  test 'Blog :: should target controller and action for feed url' do
    assert_routing '/blog_feed.atom', controller: 'posts', action: 'blog', locale: 'fr', format: 'atom' if @locales.include?(:fr)
    assert_routing '/en/blog_feed.atom', controller: 'posts', action: 'blog', locale: 'en', format: 'atom' if @locales.include?(:en)
  end

  test 'Blog :: should redirect to correct atom version by locale' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :blog, format: :rss, locale: locale.to_s
        assert_redirected_to action: :blog, format: :atom, locale: locale.to_s
      end
    end
  end

  #
  # == Events
  #
  test 'Event :: should get atom page' do
    @locales.each do |locale|
      get :event, format: :atom, locale: locale.to_s
      assert_response :success
    end
  end

  test 'Event :: should use feed template' do
    @locales.each do |locale|
      get :event, format: :atom, locale: locale.to_s
      assert_template :feed, layout: false
    end
  end

  test 'Event :: should target controller and action for feed url' do
    assert_routing '/event_feed.atom', controller: 'posts', action: 'event', locale: 'fr', format: 'atom' if @locales.include?(:fr)
    assert_routing '/en/event_feed.atom', controller: 'posts', action: 'event', locale: 'en', format: 'atom' if @locales.include?(:en)
  end

  test 'Event :: should redirect to correct atom version by locale' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :event, format: :rss, locale: locale.to_s
        assert_redirected_to action: :event, format: :atom, locale: locale.to_s
      end
    end
  end

  #
  # == Abilities
  #
  test 'should test abilities for subscriber' do
    sign_in @subscriber
    ability = Ability.new(@subscriber)
    assert ability.can?(:feed, Post.new), 'should be able to see feed'

    @rss_module.update_attribute(:enabled, false)
    ability = Ability.new(@subscriber)
    assert ability.cannot?(:feed, Post.new), 'should not be able to see feed'
  end

  test 'should test abilities for administrator' do
    sign_in @administrator
    ability = Ability.new(@administrator)
    assert ability.can?(:feed, Post.new), 'should be able to see feed'

    @rss_module.update_attribute(:enabled, false)
    ability = Ability.new(@administrator)
    assert ability.cannot?(:feed, Post.new), 'should not be able to see feed'
  end

  test 'should test abilities for super_administrator' do
    sign_in @super_administrator
    ability = Ability.new(@super_administrator)
    assert ability.can?(:feed, Post.new), 'should be able to see feed'

    @rss_module.update_attribute(:enabled, false)
    ability = Ability.new(@super_administrator)
    assert ability.cannot?(:feed, Post.new), 'should not be able to see feed'
  end

  #
  # == Module disabled
  #
  test 'should render 404 if RSS module is diabled' do
    disable_optional_module @super_administrator, @rss_module, 'RSS' # in test_helper.rb
    sign_in @administrator
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :feed, format: :atom, locale: locale.to_s
        assert_redirected_to root_path(locale: locale.to_s)
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
