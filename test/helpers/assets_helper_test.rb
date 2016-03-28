# frozen_string_literal: true
require 'test_helper'

#
# == AssetsHelper Test
#
class AssetsHelperTest < ActionView::TestCase
  setup :initialize_test

  test 'should return full path for attachment' do
    @subscriber = users(:lana)
    result = attachment_url(@subscriber.avatar, :small, ActionController::TestRequest.new)
    expected = "http://test.host/system/test/users/#{@subscriber.id}/small-bart.jpg"

    assert_equal expected, result
  end

  test 'should return default image if attachment is not defined' do
    @administrator = users(:bob)
    result = attachment_url(@administrator.avatar, :small, ActionController::TestRequest.new)
    expected = 'http://test.host/default/small-missing.png'

    assert_equal expected, result
  end

  test 'should return default picture if attachment is nil' do
    result = attachment_url(nil, :small, ActionController::TestRequest.new)
    expected = 'http://test.host/default/small-missing.png'
    assert_equal expected, result
  end

  #
  # == Pictures
  #
  test 'should return retina avatar for user' do
    attachment = fixture_file_upload 'images/bart.png', 'image/png'
    @user.update_attributes!(avatar: attachment)
    assert_equal "<img width=\"64\" height=\"64\" src=\"#{@user.avatar.url(:small)}\" alt=\"Small bart\" />", retina_thumb_square(@user)
  end

  #
  # == Video
  #
  test 'should return false if video_module disabled' do
    assert_not show_video_background?(@video_settings, @video_module_disabled), 'should be false'
  end

  test 'should return true if video_upload and video_background are enabled' do
    assert show_video_background?(@video_settings, @video_module), 'should be true'
  end

  test 'should return false if video_upload is enabled but not video_background' do
    @video_settings.update_attributes(video_background: '0')
    assert_not show_video_background?(@video_settings, @video_module), 'should be false'
  end

  test 'should return false if video_background is enabled but not video_upload' do
    @video_settings.update_attributes(video_upload: '0')
    assert_not show_video_background?(@video_settings, @video_module), 'should be false'
  end

  private

  def initialize_test
    @video_settings = video_settings(:one)
    @user = users(:maria)

    @video_module = optional_modules(:video)
    @video_module_disabled = optional_modules(:video_disabled)
  end
end
