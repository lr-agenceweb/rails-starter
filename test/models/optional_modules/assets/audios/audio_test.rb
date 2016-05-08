# frozen_string_literal: true
require 'test_helper'

#
# == Audio model test
#
class AudioTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  #
  # == Validation rules
  #
  test 'should upload audio if all validations matched' do
    @file.stubs(:size).returns(1.megabytes)
    @file.stubs(:content_type).returns('audio/mp3')

    audio = Audio.new @attrs
    assert audio.errors.keys.empty?
    assert audio.valid?, 'should be valid'
  end

  test 'should not upload audio if file size is too heavy' do
    skip 'Don\'t know how to stub paperclip file size'
    @file.stubs(:size).returns(50.megabytes)
    @file.stubs(:content_type).returns('audio/mpeg')

    audio = Audio.new @attrs
    assert_not audio.valid?, 'should not be valid'
    assert_equal [:audio_size], audio.errors.keys
  end

  test 'should not upload audio if content_type is not allowed' do
    @file.stubs(:size).returns(1.megabytes)
    @file.stubs(:content_type).returns('video/mp4')

    audio = Audio.new @attrs
    assert_not audio.valid?, 'should not be valid'
    assert_equal [:audio_content_type, :audio], audio.errors.keys
  end

  #
  # == Flash content
  #
  test 'should not have flash content if no audio is uploaded' do
    @audio.save!
    assert @audio.valid?, 'should be valid'
    assert_empty @audio.errors.keys
    assert @audio.audio_flash_notice.blank?
  end

  test 'should not have flash content after destroying audio' do
    @audio.destroy
    assert @audio.audio_flash_notice.blank?
  end

  test 'should return correct flash content after updating an audio file' do
    audio = fixture_file_upload 'audios/test.mp3', 'audio/mpeg'
    @audio.update_attribute(:audio, audio)
    assert @audio.valid?, 'should be valid'
    assert_empty @audio.errors.keys
    assert_equal I18n.t('audio.flash.upload_in_progress'), @audio.audio_flash_notice
  end

  private

  def initialize_test
    @blog = blogs(:blog_online)
    @audio = audios(:one)
    @file = fixture_file_upload('audios/test.mp3', 'audio/mpeg')
    set_attrs
  end

  def set_attrs
    @attrs = {
      audioable_id: @blog.id,
      audioable_type: @blog.class.to_s,
      audio: @file
    }
  end
end
