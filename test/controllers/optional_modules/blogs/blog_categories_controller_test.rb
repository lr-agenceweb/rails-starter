# frozen_string_literal: true
require 'test_helper'

#
# == BlogCategoriesController Test
#
class BlogCategoriesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  include Rails.application.routes.url_helpers

  setup :initialize_test

  #
  # == Routes / Templates / Responses
  #
  test 'should get show' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, locale: locale.to_s, id: @blog_category
        assert_response :success
        assert_not_nil assigns(:blogs)
        assert_template :show
      end
    end
  end

  test 'AJAX :: should get show' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        xhr :get, :show, locale: locale.to_s, id: @blog_category
        assert_response :success
        assert_not_nil assigns(:blogs)
        assert_template 'blogs/index'
      end
    end
  end

  test 'assert integrity of request for each locales' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, locale: locale.to_s, id: @blog_category
        assert_equal request.path_parameters[:id], @blog_category.slug
        assert_equal request.path_parameters[:locale], locale.to_s
      end
    end
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
          get :show, locale: locale.to_s, id: @blog_category
        end
      end
    end
  end

  #
  # == Category not found
  #
  test 'should render 404 if trying to access unexisting blog_category' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        assert_raises(ActiveRecord::RecordNotFound) do
          get :show, locale: locale.to_s, id: 'foobar'
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
          get :show, locale: locale.to_s, id: @blog_category
        end
      end
    end
  end

  #
  # == Maintenance
  #
  test 'should render maintenance if enabled and not connected' do
    assert_maintenance_frontend(:show, @blog_category)
  end

  test 'should not render maintenance even if enabled and SA' do
    sign_in @super_administrator
    assert_no_maintenance_frontend(:show, @blog_category)
  end

  test 'should not render maintenance even if enabled and Admin' do
    sign_in @administrator
    assert_no_maintenance_frontend(:show, @blog_category)
  end

  test 'should render maintenance if enabled and subscriber' do
    sign_in @subscriber
    assert_maintenance_frontend(:show, @blog_category)
  end

  private

  def initialize_test
    @locales = I18n.available_locales
    @setting = settings(:one)
    @menu = menus(:blog)

    @blog_module = optional_modules(:blog)
    @blog_category = blog_categories(:one)

    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)
  end
end
