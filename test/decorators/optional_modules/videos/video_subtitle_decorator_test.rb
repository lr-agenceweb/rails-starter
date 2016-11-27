# frozen_string_literal: true
require 'test_helper'

#
# VideoSubtitleDecorator test
# =============================
class VideoSubtitleDecoratorTest < Draper::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  #
  # ActiveAdmin
  # =============
  test 'should return correct hint for paperclip' do
    default_hint = I18n.t('formtastic.hints.video_subtitle.subtitle_fr')
    assert_equal default_hint, VideoSubtitle.new.decorate.hint_for_paperclip

    attachment = fixture_file_upload 'videos/subtitle.srt', 'text/srt'
    @video_subtitle.update_attributes(subtitle_fr: attachment)
    expected = "#{default_hint}<br />#{@video_subtitle.subtitle_fr_file_name} le #{I18n.l(@video_subtitle.created_at, format: :short)}"
    assert_equal expected, @video_subtitle_decorated.hint_for_paperclip

    assert_equal I18n.t('formtastic.hints.video_subtitle.subtitle_en'), @video_subtitle_decorated.hint_for_paperclip(attribute: :subtitle_en)
  end

  def initialize_test
    @video_subtitle = video_subtitles(:one)
    @video_subtitle_decorated = VideoSubtitleDecorator.new(@video_subtitle)
  end
end
