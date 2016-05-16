# frozen_string_literal: true
require 'test_helper'

#
# == VideoUpload model test
#
class VideoUploadTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  #
  # == Flash content
  #
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
