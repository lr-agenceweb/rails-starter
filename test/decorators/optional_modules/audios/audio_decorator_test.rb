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

  private

  def initialize_test
    @audio = audios(:one)
    @audio_decorated = AudioDecorator.new(@audio)
  end
end
