# frozen_string_literal: true
require 'test_helper'

#
# ErrorsController Test
# =======================
class ErrorsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup :initialize_test

  #
  # Show action
  # =============
  test 'should get show with error code 404' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, params: { code: '404', locale: locale.to_s }
        assert_response 404
        assert_template '404'
        assert_template layout: :error
      end
    end
  end

  test 'should get show with error code 422' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, params: { code: '422', locale: locale.to_s }
        assert_response 422
        assert_template '422'
        assert_template layout: :error
      end
    end
  end

  test 'should get show with error code 500' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, params: { code: '500', locale: locale.to_s }
        assert_response 500
        assert_template '500'
        assert_template layout: :error
      end
    end
  end

  #
  # By routes
  # ===========
  test 'should get errors controller targetting /404' do
    assert_routing '/404', controller: 'errors', action: 'show', code: '404', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/404', controller: 'errors', action: 'show', code: '404', locale: 'en' if @locales.include?(:en)
  end

  test 'should get errors controller targetting /422' do
    assert_routing '/422', controller: 'errors', action: 'show', code: '422', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/422', controller: 'errors', action: 'show', code: '422', locale: 'en' if @locales.include?(:en)
  end

  test 'should get errors controller targetting /500' do
    assert_routing '/500', controller: 'errors', action: 'show', code: '500', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en/500', controller: 'errors', action: 'show', code: '500', locale: 'en' if @locales.include?(:en)
  end

  private

  def initialize_test
    @locales = I18n.available_locales
  end
end
