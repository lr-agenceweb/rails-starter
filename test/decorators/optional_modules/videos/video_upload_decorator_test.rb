require 'test_helper'

#
# == VideoUploadDecorator test
#
class VideoUploadDecoratorTest < Draper::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  test 'should get correct title for microdatas' do
    assert_equal 'Landscape.mp4', @video_upload_decorated.title_microdatas
    assert_equal 'Paysages de France', @video_upload_two_decorated.title_microdatas
  end

  test 'should get correct description for microdatas' do
    assert_equal 'Landscape.mp4', @video_upload_decorated.description_microdatas
    assert_equal '<p>Vidéo présentant les paysages de France</p>', @video_upload_two_decorated.description_microdatas
  end

  test 'should get correct preview image tag' do
    assert_equal '<img src="/system/test/video_uploads/980190962/preview-landscape.jpg" alt="Preview landscape" />', @video_upload_decorated.preview
  end

  test 'should not be linked to a category' do
    assert_not @video_upload_decorated.category?
  end

  test 'should be linked to a category' do
    assert @video_upload_two_decorated.category?
  end

  #
  # == Status tag
  #
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
