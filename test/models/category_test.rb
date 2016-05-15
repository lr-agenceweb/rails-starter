# frozen_string_literal: true
require 'test_helper'

#
# == Category model test
#
class CategoryTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  test 'should return title for category' do
    assert_equal 'Accueil', Category.title_by_category(@category.name)
  end

  test 'should return only allowed modules' do
    assert_equal 10, Category.with_allowed_module.count
  end

  #
  # == Flash content
  #
  test 'should not have flash content if no video are uploaded' do
    @category.save!
    assert @category.video_upload.video_flash_notice.blank?
  end

  test 'should return correct flash content after updating a video' do
    video = fixture_file_upload 'videos/test.mp4', 'video/mp4'
    @category.update_attributes(video_upload_attributes: { video_file: video })
    @category.save!
    assert_equal I18n.t('video_upload.flash.upload_in_progress'), @category.video_upload.video_flash_notice
  end

  #
  # == Slider
  #
  test 'should have a slider linked for home category' do
    assert @category.slider?
  end

  test 'should not have any slider linked for search category' do
    assert_not @search_category.slider?
  end

  private

  def initialize_test
    @category = categories(:home)
    @search_category = categories(:search)
  end
end
