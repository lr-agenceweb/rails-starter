require 'test_helper'

#
# == Social Model test
#
class SocialTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  test 'should count social network with share kind' do
    assert_equal 1, Social.share.count
  end

  test 'should count social network with follow kind' do
    assert_equal 2, Social.follow.count
  end

  test 'should return list of allowed title for social' do
    atsn = Social.allowed_title_social_network
    assert_includes atsn, 'Facebook'
    assert_includes atsn, 'Twitter'
    assert_includes atsn, 'Google+'
    assert_includes atsn, 'Email'
  end

  test 'should return list of allowed kind for social' do
    aksn = Social.allowed_kind_social_network.flatten(1)
    assert_includes aksn, 'follow'
    assert_includes aksn, 'share'
  end

  test 'should return list of allowed font awesome for social' do
    afai = Social.allowed_font_awesome_ikons
    assert_includes afai, 'facebook'
    assert_includes afai, 'twitter'
    assert_includes afai, 'google'
    assert_includes afai, 'envelope'
  end

  #
  # == Validation
  #
  test 'should save follow social if all good' do
    social = Social.new(title: 'Facebook', kind: 'follow', link: 'http://facebook.com', font_ikon: 'facebook')
    assert social.valid?
    assert_empty social.errors.keys
  end

  test 'should save share social if all good' do
    social = Social.new(title: 'Facebook', kind: 'share', font_ikon: 'facebook')
    assert social.valid?
    assert_empty social.errors.keys
  end

  test 'should not be valid if title is not set' do
    social = Social.new(kind: 'share')
    assert_not social.valid?
    assert_equal [:title], social.errors.keys
  end

  test 'should not be valid if kind is not allowed' do
    social = Social.new(title: 'Facebook', kind: 'bad_value')
    assert_not social.valid?
    assert_equal [:kind], social.errors.keys
  end

  test 'should not save link if social kind is share' do
    social = Social.new(title: 'Facebook', kind: 'share', link: 'http://facebook.com')
    assert_not social.valid?
    assert_equal [:link], social.errors.keys
  end

  test 'should not save link if url is not correct' do
    social = Social.new(title: 'Facebook', kind: 'share', link: 'http://facebook')
    assert_not social.valid?
    assert_equal [:link], social.errors.keys
  end

  test 'should not save ikon if not allowed' do
    social = Social.new(title: 'Email', kind: 'share', font_ikon: 'car')
    assert_not social.valid?
    assert_equal [:font_ikon], social.errors.keys
  end

  #
  # == Ikon
  #
  test 'should not upload ikon if mime type is not allowed' do
    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_nil @social.ikon.path(size)
    end

    attachment = fixture_file_upload 'images/fake.txt', 'text/plain'
    @social.update_attributes(ikon: attachment)

    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_not_processed 'fake.txt', size, @social.ikon
    end
  end

  test 'should upload ikon if mime type is allowed' do
    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_nil @social.ikon.path(size)
    end

    attachment = fixture_file_upload 'images/social.png', 'image/png'
    @social.update_attributes!(ikon: attachment)

    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_processed 'social.png', size, @social.ikon
    end
  end

  private

  def initialize_test
    @social = socials(:facebook_follow)
  end
end
