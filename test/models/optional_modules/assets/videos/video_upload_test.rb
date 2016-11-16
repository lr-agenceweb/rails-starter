# frozen_string_literal: true
require 'test_helper'

#
# VideoUpload Model test
# ========================
class VideoUploadTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  # Constants
  SIZE_PLUS_1 = VideoUpload::ATTACHMENT_MAX_SIZE + 1

  #
  # Shoulda
  # =========
  should belong_to(:videoable)
  should have_one(:video_subtitle)
  should accept_nested_attributes_for(:video_subtitle)

  should have_attached_file(:video_file)
  should_not validate_attachment_presence(:video_file)
  should validate_attachment_content_type(:video_file)
    .allowing('video/mp4', 'video/ogv', 'video/webm')
    .rejecting('text/plain', 'text/xml')
  should validate_attachment_size(:video_file)
    .less_than((SIZE_PLUS_1 - 1).megabytes)

  #
  # Flash content
  # ===============
  test 'should not have flash content if no video is uploaded' do
    @video_upload.save!
    assert @video_upload.valid?, 'should be valid'
    assert_empty @video_upload.errors.keys
    assert @video_upload.video_upload_flash_notice.blank?
  end

  test 'should not have flash content after destroying video' do
    @video_upload.destroy
    assert @video_upload.video_upload_flash_notice.blank?
  end

  test 'should return correct flash content after updating an video file' do
    @video_upload.update_attribute(:video_file, @file)
    assert @video_upload.valid?, 'should be valid'
    assert_empty @video_upload.errors.keys
    assert_equal I18n.t('video_upload.flash.upload_in_progress'), @video_upload.video_upload_flash_notice
  end

  private

  def initialize_test
    @blog = blogs(:blog_online)
    @video_upload = video_uploads(:three)
    @file = fixture_file_upload('videos/test.mp4', 'video/mp4')
    set_attrs
  end

  def set_attrs
    @attrs = {
      videoable_id: @blog.id,
      videoable_type: @blog.class.to_s,
      video_file: @file
    }
  end
end
