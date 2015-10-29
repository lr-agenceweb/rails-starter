require 'test_helper'

#
# == Blog model test
#
class BlogTest < ActiveSupport::TestCase
  test 'should return correct count for blogs posts' do
    assert_equal 2, Blog.count
  end

  test 'should fetch only online blog posts' do
    assert_equal 1, Blog.online.count
  end
end
