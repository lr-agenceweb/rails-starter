# frozen_string_literal: true
require 'test_helper'

#
# == ApplicationController Test
#
class ApplicationControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup :initialize_test

  test 'should render 404' do
    assert_raises(ActionController::RoutingError) do
      @controller.not_found
    end
  end

  test 'should return correct language' do
    make_get_index(assertions) do
      assert_equal :fr, assigns(:language)
    end

    make_get_index(assertions, :en) do
      assert_equal :en, assigns(:language)
    end
  end

  test 'should return correct Froala wysiwyg key' do
    params = { froala_key: Figaro.env.froala_key }
    assert_equal params, @controller.send(:set_froala_key)
  end

  test 'should not have nil legal_notice content' do
    make_get_index(assertions) do
      assert_not assigns(:page_legal_notice).nil?
      assert_equal 'LegalNotice', assigns(:page_legal_notice).name
    end
  end

  #
  # == AdminBarable
  #
  test 'should not have nil module settings content if logged in as administrator' do
    sign_in users(:bob)
    assert @setting.show_admin_bar?
    make_get_index(assertions) do
      assert_not assigns(:comment_setting_admin_bar).nil?
      assert_not assigns(:guest_book_setting_admin_bar).nil?
    end
  end

  test 'should have nil module settings content if not logged in as administrator' do
    assert @setting.show_admin_bar?
    make_get_index(assertions) do
      assert_nil assigns(:comment_setting_admin_bar)
      assert_nil assigns(:guest_book_setting_admin_bar)
    end
  end

  test 'should have nil module settings if admin_bar disabled' do
    @setting.update_attribute(:show_admin_bar, false)
    assert_not @setting.show_admin_bar?
    make_get_index(assertions) do
      assert assigns(:comment_setting_admin_bar).nil?
      assert assigns(:guest_book_setting_admin_bar).nil?
    end
  end

  test 'should not have cookie cnil checked' do
    assert_not @controller.cookie_cnil_check?
  end

  #
  # == Concern
  #
  test 'should not have newsletter_user with nil value' do
    make_get_index(assertions) do
      assert_not assigns(:newsletter_user).nil?
    end
  end

  #
  # == Analytical
  #
  test 'should be true for analytical_modules? if all good' do
    good_analytical_conditions
    assert_not @controller.send(:analytical_modules?), 'analytical should not be disabled'
    reset_analytical_conditions
  end

  test 'should be false for analytical_modules? if env is not production' do
    good_analytical_conditions
    Rails.env = 'test'
    assert_not Rails.env.production?
    assert @controller.send(:analytical_modules?), 'analytical should be disabled'
    reset_analytical_conditions
  end

  test 'should be false for analytical_modules? with google_analytics_key blank' do
    good_analytical_conditions
    ENV['google_analytics_key'] = nil
    assert Figaro.env.google_analytics_key.blank?
    assert @controller.send(:analytical_modules?), 'analytical should be disabled'
    reset_analytical_conditions
  end

  test 'should be false for analytical_modules? if DNT is enabled' do
    good_analytical_conditions
    @request.env['HTTP_DNT'] = '1'
    assert_equal '1', @request.headers['HTTP_DNT']
    assert @controller.send(:analytical_modules?), 'analytical should be disabled'
    reset_analytical_conditions
  end

  test 'should be false for analytical_modules? if Analytics module is disabled' do
    good_analytical_conditions
    @analytics_module.update_attribute(:enabled, false)
    assert_not @analytics_module.enabled?
    assert @controller.send(:analytical_modules?), 'analytical should be disabled'
    reset_analytical_conditions
  end

  private

  def initialize_test
    @locales = I18n.available_locales
    @setting = settings(:one)
    @analytics_module = optional_modules(:analytics)
  end

  def make_get_index(assertions, loc = I18n.default_locale)
    old_controller = @controller
    @controller = HomesController.new
    get :index, params: { locale: loc.to_s }
    yield(assertions)
  ensure
    @controller = old_controller
  end

  def good_analytical_conditions
    Rails.env = 'production'
    assert Rails.env.production?

    @controller.instance_variable_set(:@analytics_module, @analytics_module)

    @request.env['HTTP_DNT'] = '0'
    assert_equal '0', @request.headers['HTTP_DNT']

    @request.cookies['cookie_cnil_cancel'] = '0'

    ENV['google_analytics_key'] = 'my_key'
    assert_equal 'my_key', Figaro.env.google_analytics_key
  end

  def reset_analytical_conditions
    Rails.env = 'test'
    @request.env['HTTP_DNT'] = '1'
    ENV['google_analytics_key'] = nil
    @request.cookies['cookie_cnil_cancel'] = '1'
  end
end
