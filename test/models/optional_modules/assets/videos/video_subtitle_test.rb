# frozen_string_literal: true
require 'test_helper'

#
# VideoSubtitle Model test
# ==========================
class VideoSubtitleTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  #
  # Shoulda
  # =========
  should belong_to(:subtitleable)

  should have_attached_file(:subtitle_fr)
  should_not validate_attachment_presence(:subtitle_fr)

  should have_attached_file(:subtitle_en)
  should_not validate_attachment_presence(:subtitle_en)

  #
  # Boolean
  # =========
  test 'should return correct value for subtitle? boolean' do
    assert_not @video_upload.video_subtitle.subtitle_fr?
    assert_not @video_upload.video_subtitle.subtitle_en?

    attachment = fixture_file_upload 'videos/subtitle.srt', 'text/srt'
    @video_upload.video_subtitle.update_attributes(subtitle_fr: attachment)
    @video_upload.video_subtitle.update_attributes(subtitle_en: attachment)
    assert @video_upload.video_subtitle.subtitle_fr?
    assert @video_upload.video_subtitle.subtitle_en?
  end

  def initialize_test
    @video_upload = video_uploads(:one)
  end
end
