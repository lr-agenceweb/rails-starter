require 'test_helper'

#
# == AssetsHelper Test
#
class AssetsHelperTest < ActionView::TestCase
  include AssetsHelper

  test 'should return full path for attachment' do
    @anthony = users(:anthony)

    result = attachment_url(@anthony.avatar, :small, ActionController::TestRequest.new)
    expected = "http://test.host/system/avatar/#{@anthony.id}/small/bart.jpg"

    assert_equal result, expected
  end

  test 'should return nil if attachment is nil' do
    assert_nil attachment_url(nil, :small, ActionController::TestRequest.new)
  end
end
