require 'test_helper'

#
# == HomesController Test
#
class HomesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup :initialize_test

  test 'should get index' do
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :index, locale: locale.to_s
        assert_response :success
        assert_not_nil assigns(:homes)
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

  test 'should fetch only online posts' do
    @homes = Home.online
    assert_equal @homes.length, 1
  end

  test 'should get hompepage targetting home controller' do
    assert_routing '/', controller: 'homes', action: 'index', locale: 'fr' if @locales.include?(:fr)
    assert_routing '/en', controller: 'homes', action: 'index', locale: 'en' if @locales.include?(:en)
  end

  #
  # == Maintenance
  #
  test 'should render maintenance layout and template if setting enabled' do
    @setting.update_attribute(:maintenance, true)
    @locales.each do |locale|
      I18n.with_locale(locale) do
        get :index, locale: locale.to_s
        assert_response :success
        assert_template :maintenance
        assert_template layout: :maintenance
      end
    end
  end

  private

  def initialize_test
    @home = posts(:home)
    @locales = I18n.available_locales
    @setting = settings(:one)
  end
end
