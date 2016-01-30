
require 'test_helper'

#
# == VideoDecorator test
#
class VideoDecoratorTest < Draper::TestCase
  setup :initialize_test

  test 'should get correct source for video upload' do
    video_decorated = VideoDecorator.new(@video_upload)
    assert_equal @home, video_decorated.from_article
  end

  test 'should get correct description for video platform' do
    video_decorated = VideoDecorator.new(@video_platform)
    assert_equal 'Je suis une description de test', video_decorated.description_d
  end

  private

  def initialize_test
    @video_upload = video_uploads(:one)
    @video_platform = video_platforms(:one)
    @home = posts(:home)
  end
end
