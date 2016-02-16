require 'test_helper'

#
# == VideoSettingDecorator test
#
class VideoSettingDecoratorTest < Draper::TestCase
  setup :initialize_test

  #
  # == Status tag
  #
  test 'should return status when video platform enabled' do
    video_setting_decorated = VideoSettingDecorator.new(@video_setting)
    assert_match "<span class=\"status_tag activé green\">Activé</span>", video_setting_decorated.video_platform
  end

  test 'should return status when video platform not enabled' do
    @video_setting.update_attribute(:video_platform, false)
    video_setting_decorated = VideoSettingDecorator.new(@video_setting)
    assert_match "<span class=\"status_tag désactivé red\">Désactivé</span>", video_setting_decorated.video_platform
  end

  test 'should return status when video upload enabled' do
    video_setting_decorated = VideoSettingDecorator.new(@video_setting)
    assert_match "<span class=\"status_tag activé green\">Activé</span>", video_setting_decorated.video_upload
  end

  test 'should return status when video upload not enabled' do
    @video_setting.update_attribute(:video_upload, false)
    video_setting_decorated = VideoSettingDecorator.new(@video_setting)
    assert_match "<span class=\"status_tag désactivé red\">Désactivé</span>", video_setting_decorated.video_upload
  end

  test 'should return status when video background enabled' do
    video_setting_decorated = VideoSettingDecorator.new(@video_setting)
    assert_match "<span class=\"status_tag activé green\">Activé</span>", video_setting_decorated.video_background
  end

  test 'should return status when video background not enabled' do
    @video_setting.update_attribute(:video_background, false)
    video_setting_decorated = VideoSettingDecorator.new(@video_setting)
    assert_match "<span class=\"status_tag désactivé red\">Désactivé</span>", video_setting_decorated.video_background
  end

  test 'should return status when turn off the lights enabled' do
    video_setting_decorated = VideoSettingDecorator.new(@video_setting)
    assert_match "<span class=\"status_tag activé green\">Activé</span>", video_setting_decorated.turn_off_the_light
  end

  test 'should return status when turn off the lights not enabled' do
    @video_setting.update_attribute(:turn_off_the_light, false)
    video_setting_decorated = VideoSettingDecorator.new(@video_setting)
    assert_match "<span class=\"status_tag désactivé red\">Désactivé</span>", video_setting_decorated.turn_off_the_light
  end

  private

  def initialize_test
    @video_setting = video_settings(:one)
  end
end
