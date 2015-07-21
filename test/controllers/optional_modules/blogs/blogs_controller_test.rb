require 'test_helper'

#
# == BlogsController Test
#
class BlogsControllerTest < ActionController::TestCase
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
        assert_not_nil assigns(:blogs)
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
        get :show, locale: locale.to_s, id: @blog
        assert_response :success
      end
    end
  end

  test 'assert integrity of request for each locales' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, locale: locale.to_s, id: @blog
        assert_equal request.path_parameters[:id], @blog.slug
        assert_equal request.path_parameters[:locale], locale.to_s
      end
    end
  end

  test 'should get index page targetting blogs controller' do
    assert_routing '/blog', controller: 'blogs', action: 'index', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/blog', controller: 'blogs', action: 'index', locale: 'en' if @locales.include?(:en)
  end

  #
  # == Object
  #
  test 'should fetch only online posts' do
    @blogs = Blog.online
    assert_equal @blogs.length, 1
  end

  test 'should render 404 if blog article is offline' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_raises(ActiveRecord::RecordNotFound) do
          get :show, locale: locale.to_s, id: @blog_offline
        end
      end
    end
  end

  #
  # == Module disabled
  #
  test 'should render 404 if module is disabled' do
    disable_optional_module @anthony, @blog_module, 'Blog' # in test_helper.rb
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
    @blog = blogs(:blog_online)
    @blog_offline = blogs(:blog_offline)
    @locales = I18n.available_locales
    @blog_module = optional_modules(:blog)
    @anthony = users(:anthony)
  end
end
