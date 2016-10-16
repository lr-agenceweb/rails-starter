# frozen_string_literal: true
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

  test 'AJAX :: should get index' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        xhr :get, :index, locale: locale.to_s
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
        get :show, locale: locale.to_s, id: @blog_naked, blog_category_id: @blog_naked.blog_category
        assert_response :success
      end
    end
  end

  test 'AJAX :: should get show' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        xhr :get, :show, locale: locale.to_s, id: @blog_naked, blog_category_id: @blog_naked.blog_category
        assert_response :success
      end
    end
  end

  test 'assert integrity of request for each locales' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, locale: locale.to_s, id: @blog_naked, blog_category_id: @blog_naked.blog_category
        assert_equal request.path_parameters[:id], @blog_naked.slug
        assert_equal request.path_parameters[:locale], locale.to_s
      end
    end
  end

  test 'should get index page targetting blogs controller' do
    assert_routing '/blogs', controller: 'blogs', action: 'index', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/blogs', controller: 'blogs', action: 'index', locale: 'en' if @locales.include?(:en)
  end

  #
  # == Object
  #
  test 'should render 404 if blog article is offline' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_raises(ActiveRecord::RecordNotFound) do
          get :show, locale: locale.to_s, id: @blog_offline, blog_category_id: @blog_offline.blog_category
        end
      end
    end
  end

  #
  # == Comments
  #
  test 'should get three comments for blog article in french side' do
    I18n.with_locale(:fr) do
      assert_equal @blog_mc.comments.by_locale(:fr).count, 3
    end
  end

  if I18n.available_locales.include?(:en)
    test 'should get two comments for blog article in english side' do
      I18n.with_locale(:en) do
        assert_equal @blog_mc.comments.by_locale(:en).count, 2
      end
    end
  end

  test 'should get one comments for blog article in french side and validated' do
    I18n.with_locale(:fr) do
      assert_equal @blog_mc.comments.by_locale(:fr).validated.count, 1
    end
  end

  if I18n.available_locales.include?(:en)
    test 'should get one comments for blog article in english side and validated' do
      I18n.with_locale(:en) do
        assert_equal @blog_mc.comments.by_locale(:fr).validated.count, 1
      end
    end
  end

  test 'should get alice as comments author' do
    assert_equal @comment.user_username, 'alice'
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
          get :index, locale: locale.to_s
        end
      end
    end
  end

  #
  # == Module disabled
  #
  test 'should render 404 if module is disabled' do
    disable_optional_module @super_administrator, @blog_module, 'Blog' # in test_helper.rb
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_raises(ActionController::RoutingError) do
          get :index, locale: locale.to_s
        end
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
    @blog = blogs(:blog_online)
    @blog_mc = blogs(:many_comments)
    @blog_offline = blogs(:blog_offline)
    @blog_naked = blogs(:naked)
    @blog_module = optional_modules(:blog)

    @comment = comments(:three)

    @locales = I18n.available_locales
    @setting = settings(:one)
    @menu = menus(:blog)

    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)
  end
end
