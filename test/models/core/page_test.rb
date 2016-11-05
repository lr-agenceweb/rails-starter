# frozen_string_literal: true
require 'test_helper'

#
# == Page model test
#
class PageTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  test 'should return title for page' do
    assert_equal 'Accueil', Page.title_by_page(@page_home.name)
  end

  test 'should return only allowed modules' do
    assert_equal 10, Page.with_allowed_module.count
  end

  #
  # == Flash content
  #
  test 'should not have flash content if no video are uploaded' do
    @page_home.save!
    assert @page_home.video_upload.video_upload_flash_notice.blank?
  end

  test 'should return correct flash content after updating a video' do
    video = fixture_file_upload 'videos/test.mp4', 'video/mp4'
    @page_home.update_attributes(video_upload_attributes: { video_file: video })
    @page_home.save!
    assert_equal I18n.t('video_upload.flash.upload_in_progress'), @page_home.video_upload.video_upload_flash_notice
  end

  #
  # == Slider
  #
  test 'should have a slider linked for home page' do
    assert @page_home.slider?
  end

  test 'should not have any slider linked for search page' do
    assert_not @page_search.slider?
  end

  private

  def initialize_test
    @page_home = pages(:home)
    @page_search = pages(:search)
  end
end
