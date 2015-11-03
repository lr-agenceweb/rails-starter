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

  private

  def initialize_test
    @adult_setting = adult_settings(:one)
    @adult_module = optional_modules(:adult)
  end
end
