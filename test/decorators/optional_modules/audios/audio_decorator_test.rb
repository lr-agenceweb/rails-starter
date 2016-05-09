# frozen_string_literal: true
require 'test_helper'

#
# == AudioDecorator test
#
class AudioDecoratorTest < Draper::TestCase
  setup :initialize_test

  #
  # == File
  #
  test 'should return correct file name without extension' do
    assert_equal 'Foo bar 2016', @audio_decorated.file_name_without_extension
  end

  test 'should return correct hint for file' do
    assert_equal 'Fichier actuel: <strong>Foo bar 2016.mp3</strong> <br />', @audio_decorated.hint_for_file
    assert_equal '', Audio.new.decorate.hint_for_file
  end

  private

  def initialize_test
    @audio = audios(:one)
    @audio_decorated = AudioDecorator.new(@audio)
  end
end
