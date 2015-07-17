require 'test_helper'

#
# == AdultsController Test
#
class AdultsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include Rails.application.routes.url_helpers

  setup :initialize_test

  test 'should redirect to root page if adult module is disabled' do
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, locale: locale.to_s
        assert_redirected_to root_path
      end
    end
  end

  #
  # == Enabled adult module
  #
  test 'should get index page if adult module is enabled' do
    enable_adult_module
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, locale: locale.to_s
        assert_response :success
      end
    end
  end

  test 'should redirect to adult validation path if trying to access site' do
    enable_adult_module
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        visit_home_page(locale)
        assert_redirected_to adults_path
      end
    end
  end

  test 'should access site if checkbox is checked' do
    enable_adult_module
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        post :create, locale: locale.to_s, adult: { adult_validated: '1' }
        assert_not_nil cookies[:adult_validated], "Cookie with adult_validated key should not be nil. Debug: Cookies=#{cookies.inspect}"
        assert_redirected_to root_path
      end
    end
  end

  test 'should not access site if checkbox is not checked' do
    enable_adult_module
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        post :create, locale: locale.to_s, adult: { adult_validated: '0' }
        assert_nil cookies[:adult_validated], "Cookie with adult_validated key should be nil. Debug: Cookies=#{cookies.inspect}"
        assert_redirected_to adults_path
      end
    end
  end

  #
  # == Cookie is present
  #
  test 'should redirect to root_path if cookie is present' do
    enable_adult_module
    cookies[:adult_validated] = { value: 'adult', expires: 1.week.from_now }
    @locales.each do |locale|
      I18n.with_locale(locale.to_s) do
        get :index, locale: locale.to_s
        assert_redirected_to root_path
      end
    end
  end

  private

  def initialize_test
    @anthony = users(:anthony)
    @locales = I18n.available_locales
    @adult_module = optional_modules(:adult)
  end

  def enable_adult_module
    old_controller = @controller
    sign_in @anthony
    @controller = Admin::OptionalModulesController.new
    patch :update, id: @adult_module, optional_module: { enabled: true }
    assert assigns(:optional_module).enabled
    assert_redirected_to admin_optional_module_path(assigns(:optional_module))
    sign_out @anthony
  ensure
    @controller = old_controller
  end

  def visit_home_page(locale)
    old_controller = @controller
    @controller = HomesController.new
    get :index, locale: locale.to_s
  ensure
    @controller = old_controller
  end
end
