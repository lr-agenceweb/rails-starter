require 'test_helper'

#
# == AssetsHelper Test
#
class AssetsHelperTest < ActionView::TestCase
  include AssetsHelper

  # TODO: fix this broken test with paperclip-dropbox
  # test 'should return full path for attachment' do
  #   @lana = users(:lana)
  #   result = attachment_url(@lana.avatar, :small, ActionController::TestRequest.new)
  #   expected = "http://test.host/avatar/#{@lana.id}/small-bart.jpg"

  #   assert_equal result, expected
  # end

  test 'should return default image if attachment is not defined' do
    @bob = users(:bob)
    result = attachment_url(@bob.avatar, :small, ActionController::TestRequest.new)
    expected = 'http://test.host/default/small-missing.png'

    assert_equal result, expected
  end

  test 'should return nil if attachment is nil' do
    assert_nil attachment_url(nil, :small, ActionController::TestRequest.new)
  end
end
