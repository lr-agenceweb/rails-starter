# frozen_string_literal: true
require 'test_helper'

#
# == Blog model test
#
class BlogTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  #
  # == Count
  #
  test 'should return correct count for blogs posts' do
    assert_equal 3, Blog.count
  end

  test 'should fetch only online blog posts' do
    assert_equal 2, Blog.online.count
  end

  #
  # == Prev / Next
  #
  test 'should have a next record' do
    assert @blog.next?, 'should have a next record'
  end

  test 'should have a prev record' do
    assert @blog_third.prev?, 'should have a prev record'
  end

  test 'should not have a prev record' do
    assert_not @blog.prev?, 'should not have a prev record'
  end

  test 'should not have a next record' do
    assert_not @blog_third.next?, 'should not have a next record'
  end

  #
  # == Flash content
  #
  test 'should not have flash content if no video are uploaded' do
    @blog.save!
    assert @blog.flash_notice.blank?
  end

  test 'should return correct flash content after updating a video' do
    video = fixture_file_upload 'videos/test.mp4', 'video/mp4'
    @blog.update_attributes(video_uploads_attributes: [{ video_file: video }, { video_file: video }])
    @blog.save!
    assert_equal I18n.t('video_upload.flash.upload_in_progress'), @blog.flash_notice
  end

  private

  def initialize_test
    @blog = blogs(:blog_online)
    @blog_third = blogs(:blog_third)
  end
end
