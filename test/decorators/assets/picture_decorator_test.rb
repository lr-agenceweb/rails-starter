# frozen_string_literal: true
require 'test_helper'

#
# == PictureDecorator test
#
class PictureDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # == Image
  #
  test 'should return correct base image tag' do
    assert_equal "<img src=\"/system/test/pictures/#{@picture.id}/large-my-picture.jpg\" alt=\"Large my picture\" />", @picture_decorated.send(:base_image, :large)
  end

  #
  # == Informations
  #
  test 'should return correct title for picture if any' do
    assert_equal "Image article d'accueil", @picture_decorated.title
  end

  test 'should return correct description for picture if any' do
    assert_equal "<p>Image principale de l'article d'accueil</p>", @picture_decorated.description
  end

  test 'should return nil if no title for picture' do
    assert_nil @picture_two_decorated.title
  end

  test 'should return nil if no description for picture' do
    assert_nil @picture_two_decorated.description
  end

  test 'should return correct source picture title link html tags' do
    assert_equal "<a href=\"/admin/homes/article-d-accueil\">Article d'accueil</a>", @picture_decorated.source_picture_title_link
  end

  test 'should return correct source object for picture' do
    assert_equal @post_home, @picture_decorated.send(:source_picture)
  end

  test 'should return correct source picture title' do
    assert_equal 'Article d\'accueil', @picture_decorated.send(:source_picture_title)
  end

  private

  def initialize_test
    @post_home = posts(:home)
    @picture = pictures(:home)
    @picture_two = pictures(:home_two)

    @picture_decorated = PictureDecorator.new(@picture)
    @picture_two_decorated = PictureDecorator.new(@picture_two)
  end
end
