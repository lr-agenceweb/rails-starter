# frozen_string_literal: true
require 'test_helper'

#
# AudioDecorator test
# =====================
class AudioDecoratorTest < Draper::TestCase
  setup :initialize_test

  #
  # File
  # ======
  test 'should return correct file name without extension' do
    assert_equal 'Foo bar 2016', @audio_decorated.file_name_without_extension
  end

  test 'should return correct hint for file' do
    default_hint = I18n.t('formtastic.hints.audio.audio_file')
    assert_equal default_hint, Audio.new.decorate.hint_for_paperclip

    assert_equal "#{default_hint}<br />#{I18n.t('formtastic.hints.audio.actual_file', file: '<strong>Foo bar 2016.mp3</strong>')}", @audio_decorated.hint_for_paperclip
  end

  private

  def initialize_test
    @audio = audios(:one)
    @audio_decorated = AudioDecorator.new(@audio)
  end
end
