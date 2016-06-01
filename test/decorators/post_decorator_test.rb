# frozen_string_literal: true
require 'test_helper'

#
# == PostDecorator test
#
class PostDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers
  include ActionDispatch::TestProcess

  setup :initialize_test

  #
  # Post informations
  #
  test 'should return correct author for post' do
    assert_equal 'bob', @post_decorated.author
  end

  test 'should return correct admin author url for post' do
    assert_equal '<a href="/admin/users/bob">bob</a>', @post_decorated.link_author
  end

  test 'should return correct content' do
    assert_equal '<p>Premier article d\'accueil</p>', @post_decorated.content
  end

  test 'should return correct page for post' do
    assert_equal 'Accueil', @post_decorated.type_title
  end

  test 'should return correct title link for home (show action)' do
    assert_equal '<a target="_blank" href="/">Article d\'accueil</a>', @post_decorated.title_front_link
  end

  test 'should return correct title link for about (show action)' do
    @post_about_decorated = PostDecorator.new(@post_about)
    assert_equal '<a target="_blank" href="/a-propos/developpement-hebergement">Développement et Hébergement</a>', @post_about_decorated.title_front_link
  end

  #
  # == User
  #
  test 'should return correct author_avatar value' do
    assert_equal retina_thumb_square(@post_decorated.user), @post_decorated.author_avatar
  end

  test 'should return correct author_with_avatar value' do
    assert_equal "<div class=\"author-with-avatar\">#{retina_thumb_square(@post_decorated.user)} <br /> <a href=\"/admin/users/bob\">bob</a></div>", @post_decorated.author_with_avatar
  end

  #
  # == Picture
  #
  test 'should return correct content for image method' do
    attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
    @post_decorated.picture.update_attributes(image: attachment)

    assert_equal "<img width=\"90\" height=\"50\" src=\"#{@post_decorated.picture.image.url(:small)}\" alt=\"Small background paris\" />", @post_decorated.image
    assert_equal 'Pas d\'image', @post_about_decorated.image
  end

  test 'should return correct content for image_and_content' do
    attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
    @post_decorated.picture.update_attributes(image: attachment)

    assert_equal "<p>Premier article d'accueil</p><img src=\"#{attachment_url(@post_decorated.picture.image, :medium)}\" alt=\"Medium background paris\" />", @post_decorated.image_and_content
    assert @post_about_decorated.image_and_content.blank?
  end

  #
  # == Custom cover
  #
  test 'should return picture cover if any' do
    @blog_decorated.pictures.each(&:destroy)
    @blog_decorated.video_upload.destroy
    @blog_decorated.video_platform.destroy

    pic = fixture_file_upload 'images/bart.png', 'image/png'
    Picture.create(attachable_type: 'Blog', attachable_id: @blog_decorated.id, image: pic)

    assert @blog_decorated.pictures?
    assert_not @blog_decorated.video_uploads?
    assert_not @blog_decorated.video_platforms?

    assert_equal "<img width=\"50\" height=\"90\" src=\"#{@blog_decorated.picture.image.url(:small)}\" alt=\"Small bart\" />", @blog_decorated.custom_cover
  end

  test 'should return video_upload cover if any and no picture' do
    @blog_decorated.pictures.each(&:destroy)
    @blog_decorated.video_platform.destroy

    assert_not @blog_decorated.pictures?
    assert @blog_decorated.video_uploads?
    assert_not @blog_decorated.video_platforms?

    assert_equal "<img src=\"/system/test/video_uploads/#{@blog_decorated.video_upload.id}/preview-landscape.jpg\" alt=\"Preview landscape\" />", @blog_decorated.custom_cover
  end

  test 'should return video_platform cover if no picture or video_upload' do
    @blog_decorated.pictures.each(&:destroy)
    @blog_decorated.video_upload.destroy

    assert_not @blog_decorated.pictures?
    assert_not @blog_decorated.video_uploads?
    assert @blog_decorated.video_platforms?

    assert_equal "<img src=\"http://s2.dmcdn.net/MkYFP/x240-qKj.png\" alt=\"X240 qkj\" />", @blog_decorated.custom_cover
  end

  test 'should return any cover picture if no condition works' do
    @blog_decorated.pictures.each(&:destroy)
    @blog_decorated.video_upload.destroy
    @blog_decorated.video_platform.destroy

    assert_not @blog_decorated.pictures?
    assert_not @blog_decorated.video_uploads?
    assert_not @blog_decorated.video_platforms?
    assert @blog_decorated.custom_cover.blank?
  end

  #
  # == Comment
  #
  test 'should return correct comments count by article' do
    @post_about_decorated = PostDecorator.new(@post_about_2)
    assert_equal 2, @post_about_decorated.comments_count
  end

  #
  # ActiveAdmin
  #
  test 'should return correct AA show page title' do
    assert_equal 'Article lié à la page "Accueil"', @post_decorated.title_aa_show
  end

  test 'should return correct admin_link for article' do
    assert_equal '<a href="/admin/abouts/developpement-hebergement">Voir</a>', @post_about_decorated.admin_link
  end

  private

  def initialize_test
    @post = posts(:home)
    @post_about = posts(:about)
    @post_about_2 = posts(:about_2)
    @blog = blogs(:blog_online)

    @post_decorated = PostDecorator.new(@post)
    @post_about_decorated = PostDecorator.new(@post_about)
    @blog_decorated = PostDecorator.new(@blog)
  end
end
