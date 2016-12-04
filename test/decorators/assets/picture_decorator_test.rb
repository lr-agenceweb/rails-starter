# frozen_string_literal: true
require 'test_helper'

#
# PictureDecorator test
# =======================
class PictureDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # File
  # ======
  test 'should return correct file name without extension' do
    assert_equal 'My-picture', @picture_decorated.file_name_without_extension
  end

  #
  # Image
  # =======
  test 'should return correct base image tag' do
    assert_equal "<img src=\"/system/test/pictures/#{@picture.id}/large-my-picture.jpg\" alt=\"Large my picture\" />", @picture_decorated.send(:base_image, :large)
  end

  #
  # Informations
  # ==============
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
    expected = safe_join([raw('<a href="/admin/homes/article-d-accueil">Article d\'accueil</a>')])
    assert_equal expected, @picture_decorated.source_picture_title_link
  end

  test 'should return correct source object for picture' do
    assert_equal @post_home, @picture_decorated.send(:source_picture)
  end

  test 'should return correct source picture title' do
    assert_equal 'Article d\'accueil', @picture_decorated.send(:source_picture_title)
  end

  #
  # ActiveAdmin
  # =============
  test 'should return correct hint for paperclip file' do
    default_hint = I18n.t('formtastic.hints.image')
    assert_equal "#{default_hint}<br /><img src=\"/default/medium-missing.png\" alt=\"Medium missing\" />", Picture.new.decorate.hint_for_paperclip

    assert_equal "#{default_hint}<br /><img src=\"/system/test/pictures/#{@picture_two_decorated.id}/medium-my-picture-2.jpg\" alt=\"Medium my picture 2\" />", @picture_two_decorated.hint_for_paperclip
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
