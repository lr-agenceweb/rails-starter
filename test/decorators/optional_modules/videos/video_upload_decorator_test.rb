# frozen_string_literal: true
require 'test_helper'

#
# VideoUploadDecorator test
# ============================
class VideoUploadDecoratorTest < Draper::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  #
  # Microdatas
  # ============
  test 'should get correct title for microdatas' do
    assert_equal 'Landscape.mp4', @video_upload_decorated.title_microdatas
    assert_equal 'Paysages de France', @video_upload_two_decorated.title_microdatas
  end

  test 'should get correct description for microdatas' do
    assert_equal 'Landscape.mp4', @video_upload_decorated.description_microdatas
    assert_equal '<p>Vidéo présentant les paysages de France</p>', @video_upload_two_decorated.description_microdatas
  end

  #
  # Preview
  # =========
  test 'should get loader picture if video_upload not processed' do
    expected = '<img src="/images/loader-dark.gif" alt="Loader dark" />'
    assert_equal expected, @video_upload_decorated.preview
  end

  test 'should get correct preview for video_upload if processes' do
    expected = "<img src=\"/system/test/video_uploads/#{@video_upload_two_decorated.id}/preview-landscape.jpg\" alt=\"Preview landscape\" />"
    assert_equal expected, @video_upload_two_decorated.preview
  end

  #
  # Page
  # ======
  test 'should not be linked to a page' do
    assert_not @video_upload_decorated.page?
  end

  test 'should be linked to a page' do
    assert @video_upload_two_decorated.page?
  end

  #
  # File
  # ======
  test 'should return correct file name without extension' do
    assert_equal 'Landscape', @video_upload_decorated.file_name_without_extension
  end

  #
  # Status tag
  # ============
  test 'should return correct value for subtitles?' do
    upload_subtitles
    assert @video_upload_decorated.send(:subtitles?), 'should have subtitles'
  end

  test 'should return correct status_tag for subtitles' do
    upload_subtitles
    assert @video_upload_decorated.send(:subtitles?), 'should have subtitles'

    assert_match '<span class="status_tag sous_titres_présents green">Sous Titres Présents</span>', @video_upload_decorated.subtitles
    assert_match '<span class="status_tag sous_titres_absents red">Sous Titres Absents</span>', @video_upload_two_decorated.subtitles
  end

  #
  # ActiveAdmin
  # =============
  test 'should return correct hint_for_paperclip' do
    default_hint = I18n.t('formtastic.hints.video_upload.video_file')
    assert_equal default_hint, VideoUpload.new.decorate.hint_for_paperclip

    assert_equal "#{default_hint}<br />#{I18n.t('video_upload.flash.upload_in_progress')}<br /><img src=\"/images/loader-dark.gif\" alt=\"Loader dark\" />", @video_upload_decorated.hint_for_paperclip
  end

  private

  def initialize_test
    @home = posts(:home)
    @video_upload = video_uploads(:one)
    @video_upload_two = video_uploads(:two)
    @video_upload_decorated = VideoUploadDecorator.new(@video_upload)
    @video_upload_two_decorated = VideoUploadDecorator.new(@video_upload_two)
  end

  def upload_subtitles
    assert_not @video_upload_decorated.send(:subtitles?), 'should not have subtitles'
    attachment = fixture_file_upload 'videos/subtitle.srt', 'text/srt'
    @video_upload.video_subtitle.update_attribute(:subtitle_fr, attachment)
  end
end
