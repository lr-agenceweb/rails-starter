# frozen_string_literal: true
require 'test_helper'

#
# == SettingDecorator test
#
class SettingDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers
  include AssetsHelper
  include UserHelper

  setup :initialize_test

  #
  # == Title / Subtitle
  #
  test 'should return correct title with span tag wrapping it' do
    assert_match '<span>Rails Starter</span>', @setting_decorated.title
  end

  test 'should return correct title with subtitle inline' do
    assert_equal 'Rails Starter démarre rapidement', @setting_decorated.title_subtitle_inline
  end

  test 'should return correct small subtitle formatted with html' do
    assert_match '<small class="l-header-site-subtitle">Démarre rapidement</small>', @setting_decorated.send(:small_subtitle)
  end

  test 'should return true if subtitle not blank' do
    assert @setting_decorated.send(:subtitle?)
  end

  #
  # == Logo
  #
  test 'should return nil if logo doesn\'t exisit' do
    assert_nil @setting_decorated.logo_deco
  end

  #
  # == Contact informations
  #
  test 'should return correct value for phone method' do
    assert_equal '<i class="fa fa-phone"></i> <a class="phone__link" href="tel:+33102030405">+33 (0)1 02 03 04 05</a>', @setting_decorated.phone
  end

  test 'should have correct phone value adapted for w3c' do
    assert_equal '+33102030405', @setting_decorated.phone_w3c
  end

  test 'should return correct value for email method' do
    assert_equal '<i class="fa fa-envelope"></i> <a class="email__link" href="mailto:demo@rails-starter.com">demo@rails-starter.com</a>', @setting_decorated.email
  end

  #
  # == Other
  #
  test 'should return correct credentials' do
    assert_equal "Rails Starter - Tous droits réservés - Copyright &copy; #{current_year}", @setting_decorated.credentials
  end

  test 'should have correct admin_link value if administrator' do
    sign_in @administrator
    assert_equal ' - <a target="_blank" href="/admin"> administration</a>', @setting_decorated.admin_link
  end

  test 'should have correct admin_link value if not logged_in' do
    sign_in User.new
    assert_nil @setting_decorated.admin_link
  end

  test 'should have correct about link html code' do
    assert_equal '<a href="/a-propos">À propos</a>', @setting_decorated.about
    if @locales.include?(:en)
      I18n.with_locale(:en) do
        assert_equal '<a href="/en/about">About</a>', @setting_decorated.about
      end
    end
  end

  test 'should have correct copyright value in footer' do
    assert_equal 'Tous droits réservés', @setting_decorated.send(:copyright)
  end

  private

  def initialize_test
    @setting = settings(:one)

    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)

    @locales = I18n.available_locales
    @setting_decorated = SettingDecorator.new(@setting)
  end
end
