require 'test_helper'

#
# == SocialConnectSettingDecorator
#
class SocialConnectSettingDecoratorTest < Draper::TestCase
  setup :initialize_test

  #
  # ActiveAdmin
  #
  test 'should return correct AA show page title' do
    assert_equal I18n.t('activerecord.models.social_connect_setting.one'), @social_connect_setting_decorated.title_aa_show
  end

  #
  # == Status tag
  #
  test 'should return correct status_tag if enabled' do
    assert_match "<span class=\"status_tag activé green\">Activé</span>", @social_connect_setting_decorated.status
  end

  test 'should return correct status_tag if disabled' do
    @social_connect_setting.update_attribute(:enabled, false)
    assert_match "<span class=\"status_tag désactivé red\">Désactivé</span>", @social_connect_setting_decorated.status
  end

  private

  def initialize_test
    @social_connect_setting = social_connect_settings(:one)
    @social_connect_setting_decorated = SocialConnectSettingDecorator.new(@social_connect_setting)
  end
end
