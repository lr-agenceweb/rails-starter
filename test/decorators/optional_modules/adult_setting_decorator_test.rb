require 'test_helper'

#
# == AdultSettingDecorator
#
class AdultSettingDecoratorTest < Draper::TestCase
  setup :initialize_test

  test 'should return database value for redirect_link if set' do
    adult_setting_decorated = AdultSettingDecorator.new(@adult_setting)
    assert_equal 'http://google.com', adult_setting_decorated.redirect_link_d
  end

  test 'should return default value for redirect_link if not set' do
    @adult_setting.update_attributes(redirect_link: '')
    adult_setting_decorated = AdultSettingDecorator.new(@adult_setting)
    assert_equal 'http://www.lr-agenceweb.fr', adult_setting_decorated.redirect_link_d
  end

  test 'should return correct title' do
    adult_setting_decorated = AdultSettingDecorator.new(@adult_setting)
    assert_equal 'Bienvenue sur le site de démonstration des modules !', adult_setting_decorated.title_d

    I18n.with_locale(:en) do
      assert_equal 'Welcome to the demonstration website for modules', adult_setting_decorated.title_d
    end
  end

  test 'should return correct content' do
    adult_setting_decorated = AdultSettingDecorator.new(@adult_setting)
    assert_equal '<p>Venez tester les différents modules</p>', adult_setting_decorated.content_d

    I18n.with_locale(:en) do
      assert_equal '<p>Come and test all the modules</p>', adult_setting_decorated.content_d
    end
  end

  #
  # == Status tag
  #
  test 'should return correct status_tag if enabled' do
    adult_setting_decorated = AdultSettingDecorator.new(@adult_setting)
    assert_match "<span class=\"status_tag activé green\">Activé</span>", adult_setting_decorated.status
  end

  test 'should return correct status_tag if disabled' do
    @adult_setting.update_attributes(enabled: false)
    adult_setting_decorated = AdultSettingDecorator.new(@adult_setting)
    assert_match "<span class=\"status_tag désactivé red\">Désactivé</span>", adult_setting_decorated.status
  end

  private

  def initialize_test
    @adult_setting = adult_settings(:one)
    @adult_module = optional_modules(:adult)
  end
end
