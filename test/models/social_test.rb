require 'test_helper'

#
# == Social Model test
#
class SocialTest < ActiveSupport::TestCase
  test 'should count social network with share kind' do
    assert_equal 1, Social.share.count
  end

  test 'should count social network with follow kind' do
    assert_equal 2, Social.follow.count
  end

  test 'should return list of allowed title for social newtwork' do
    assert_includes Social.allowed_title_social_network, 'Facebook'
    assert_includes Social.allowed_title_social_network, 'Twitter'
    assert_includes Social.allowed_title_social_network, 'Google+'
    assert_includes Social.allowed_title_social_network, 'Email'
  end

  test 'should return list of allowed kind for social newtwork' do
    assert_includes Social.allowed_kind_social_network, 'follow'
    assert_includes Social.allowed_kind_social_network, 'share'
  end
end
