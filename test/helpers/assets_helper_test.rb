require 'test_helper'

#
# == AssetsHelper Test
#
class AssetsHelperTest < ActionView::TestCase
  include AssetsHelper

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
end
