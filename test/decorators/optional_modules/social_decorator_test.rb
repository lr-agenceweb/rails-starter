# frozen_string_literal: true
require 'test_helper'

#
# == SocialsDecorator test
#
class SocialDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers
  include ActionDispatch::TestProcess

  setup :initialize_test

  #
  # == Font ikons
  #
  test 'should return correct font_ikons list' do
    allowed_fonts = Social.allowed_font_awesome_ikons
    %w( facebook twitter google envelope ).each do |ikon|
      assert allowed_fonts.include?(ikon), "\"#{ikon}\" should be included in list"
    end
    assert_not allowed_fonts.include?('car'), 'car should not be included in list'
  end

  test 'should return correct boolean for font_ikon?' do
    assert @facebook_follow_decorated.font_ikon?
    assert_not @twitter_follow_decorated.font_ikon?
  end

  test 'should return correct value for ikon?' do
    assert_not @facebook_share.ikon?
    upload_ikon_for_social(@facebook_share)
    assert @facebook_share.ikon?
  end

  test 'should return correct content for hint_by_ikon' do
    assert_equal "Si vous ne choisissez aucune image ou icône (#{@facebook_share_decorated.send(:font_ikon_list)}), le titre du réseau social sera utilisé.", @facebook_share_decorated.hint_by_ikon
    upload_ikon_for_social(@facebook_share)
    assert_equal 'Ce champs est désactivé car vous avez choisi d\'utiliser une image en guise d\'icône', @facebook_share_decorated.hint_by_ikon
  end

  test 'should return correct content for ikon_deco' do
    assert_equal 'Twitter', @twitter_follow_decorated.ikon_deco
    @twitter_follow_decorated.update_attribute(:font_ikon, 'twitter')
    assert_equal '<i class="fa fa-twitter fa-1x"></i>', @twitter_follow_decorated.ikon_deco
    upload_ikon_for_social(@twitter_follow)
    assert_equal "<img width=\"25\" height=\"25\" src=\"#{@twitter_follow.ikon.url(:small)}\" alt=\"Small social\" />", @twitter_follow_decorated.ikon_deco
  end

  #
  # == Link
  #
  test 'should return correct value for link if link?' do
    assert_equal '<a target="_blank" href="http://facebook.com">http://facebook.com</a>', @facebook_follow_decorated.link
  end

  test 'should return correct value for link if no link?' do
    assert @facebook_share_decorated.link.blank?
  end

  test 'should return correct value for link?' do
    assert @facebook_follow_decorated.link?
    assert_not @facebook_share_decorated.link?
  end

  #
  # == Kind
  #
  test 'should return correct kind' do
    assert_equal I18n.t("social.#{@facebook_follow.kind}"), @facebook_follow_decorated.kind
  end

  private

  def initialize_test
    @facebook_follow = socials(:facebook_follow)
    @facebook_share = socials(:facebook_share)
    @twitter_follow = socials(:twitter)

    # Decorated
    @facebook_follow_decorated = SocialDecorator.new(@facebook_follow)
    @facebook_share_decorated = SocialDecorator.new(@facebook_share)
    @twitter_follow_decorated = SocialDecorator.new(@twitter_follow)
  end

  def upload_ikon_for_social(social)
    attachment = fixture_file_upload 'images/social.png', 'image/png'
    social.update_attributes!(ikon: attachment)
  end
end
