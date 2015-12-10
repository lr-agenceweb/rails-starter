require 'test_helper'

#
# == ErrorsController Test
#
class ErrorsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup :initialize_test

  test 'should get show with error code 404' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, id: 'azaz', code: 404, locale: locale.to_s
        assert_response 404
        assert_template '404'
        assert_template layout: :error
      end
    end
  end

  test 'should get show with error code 422' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, id: 'azaz', code: 422, locale: locale.to_s
        assert_response 422
        assert_template '422'
        assert_template layout: :error
      end
    end
  end

  test 'should get show with error code 500' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :show, id: 'azaz', code: 500, locale: locale.to_s
        assert_response 500
        assert_template '500'
        assert_template layout: :error
      end
    end
  end

  private

  def initialize_test
    @locales = I18n.available_locales
  end
end
