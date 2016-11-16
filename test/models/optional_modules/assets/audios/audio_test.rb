# frozen_string_literal: true
require 'test_helper'

#
# == Audio model test
#
class AudioTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  # Constants
  SIZE_PLUS_1 = Audio::ATTACHMENT_MAX_SIZE + 1

  #
  # Shoulda
  # =========
  should belong_to(:audioable)

  should have_attached_file(:audio)
  should_not validate_attachment_presence(:audio)
  should validate_attachment_content_type(:audio)
    .allowing(Audio::ATTACHMENT_TYPES)
    .rejecting('text/plain', 'text/xml')
  should validate_attachment_size(:audio)
    .less_than((SIZE_PLUS_1 - 1).megabytes)

  #
  # == Validation rules
  #
  test 'should upload audio if all validations matched' do
    file = fixture_file_upload('audios/test.mp3', 'audio/mpeg')
    audio = Audio.new default_attrs(file)
    assert audio.errors.keys.empty?
    assert audio.valid?, 'should be valid'
  end

  # FIXME: http://stackoverflow.com/questions/37081211/trouble-trying-to-test-paperclip-file-size-with-mocha
  test 'should not upload audio if file size is too heavy' do
    skip 'Find a way to test stubbed file size'
    file = fixture_file_upload('audios/test.mp3', 'audio/mpeg')

    file.stub(:size, SIZE_PLUS_1.megabytes) do
      audio = Audio.new default_attrs(file)
      assert_equal SIZE_PLUS_1.megabytes, file.size, "file size should be #{SIZE_PLUS_1} megabytes"
      assert_not audio.valid?, 'should not be valid'
      assert_equal [:audio_size], audio.errors.keys
    end
  end

  # FIXME: http://stackoverflow.com/questions/37081211/trouble-trying-to-test-paperclip-file-size-with-mocha
  test 'should not upload audio if content_type is not allowed' do
    skip 'Find a way to test stubbed file content type'
    file = fixture_file_upload('audios/test.mp3', 'audio/mpeg')

    file.stub(:content_type, 'video/mp4') do
      audio = Audio.new default_attrs(file)
      assert_equal 'video/mp4', file.content_type, 'file content_type should be video/mp4'
      assert_not audio.valid?, 'should not be valid'
      assert_equal [:audio_content_type], audio.errors.keys
    end
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
    @audio_two.update_attribute(:audio, audio)
    assert @audio_two.valid?, 'should be valid'
    assert_empty @audio_two.errors.keys
    assert_equal I18n.t('audio.flash.upload_in_progress'), @audio_two.audio_flash_notice
  end

  private

  def initialize_test
    @blog = blogs(:blog_online)
    @audio = audios(:one)
    @audio_two = audios(:two)
  end

  def default_attrs(file)
    {
      audioable_id: @blog.id,
      audioable_type: @blog.class.to_s,
      audio: file
    }
  end
end
