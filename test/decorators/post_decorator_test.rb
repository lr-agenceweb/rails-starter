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
    @about_decorated = PostDecorator.new(@about)
    assert_equal '<a target="_blank" href="/a-propos/developpement-hebergement-avec-ruby">Développement et Hébergement avec Ruby</a>', @about_decorated.title_front_link
  end

  #
  # == Post link
  #
  test 'should return correct show_post_link content' do
    expected = blog_category_blog_path(@blog.blog_category, @blog)
    assert_equal expected, @blog_decorated.show_post_link

    expected = blog_category_blog_url(@blog.blog_category, @blog)
    assert_equal expected, @blog_decorated.show_post_link('url')

    expected = about_path(@about)
    assert_equal expected, @about_decorated.show_post_link

    expected = about_url(@about)
    assert_equal expected, @about_decorated.show_post_link('url')
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
    assert_equal I18n.t('post.no_cover'), @about_decorated.image
  end

  test 'should return correct content for image_and_content' do
    attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
    @post_decorated.picture.update_attributes(image: attachment)

    assert_equal "<p>Premier article d'accueil</p><img src=\"#{attachment_url(@post_decorated.picture.image, :medium)}\" alt=\"Medium background paris\" />", @post_decorated.image_and_content
    assert_equal 'Ruby', @about_decorated.image_and_content
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

    assert_equal "<img width=\"125\" height=\"223\" src=\"#{@blog_decorated.picture.image.url(:medium)}\" alt=\"Medium bart\" />", @blog_decorated.custom_cover
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

    assert_equal '<img src="http://s2.dmcdn.net/MkYFP/x240-qKj.png" alt="X240 qkj" />', @blog_decorated.custom_cover
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
  # == PublicationDate (publishable polymorphic)
  #
  test 'should return correct published_at content' do
    expected = '11/03/2028'
    assert_equal expected, @blog_decorated.published_at
    assert_nil @blog_naked_decorated.published_at
  end

  test 'should return correct expired_at content' do
    expected = '27/12/2028'
    assert_equal expected, @blog_decorated.expired_at
    assert_nil @blog_naked_decorated.expired_at
  end

  test 'should return content for publication' do
    expected = '<p><span class="bool-value false-value">✗</span><span>Non publié</span></p><p>Date de publication: 11/03/2028</p><p>Date d\'expiration: 27/12/2028</p>'
    assert_equal expected, @blog_decorated.publication
    assert_equal '<p><span class="bool-value true-value">✔</span><span>Publié</span></p>', @blog_naked_decorated.publication
  end

  test 'should return content for add_bool_value' do
    expected = '<p><span class="bool-value false-value">✗</span><span>Non publié</span></p>'
    assert_equal expected, @blog_decorated.send(:add_bool_value)

    expected = '<p><span class="bool-value true-value">✔</span><span>Publié</span></p>'
    assert_equal expected, @blog_naked_decorated.send(:add_bool_value)
  end

  #
  # ActiveAdmin
  #
  test 'should return correct AA show page title' do
    assert_equal 'Accueil: "Article d\'accueil"', @post_decorated.title_aa_show
  end

  test 'should return correct admin_link for article' do
    assert_equal '<a href="/admin/abouts/developpement-hebergement-avec-ruby">Voir</a>', @about_decorated.admin_link
  end

  private

  def initialize_test
    @post = posts(:home)
    @about = posts(:about)
    @blog = blogs(:blog_online)
    @blog_naked = blogs(:naked)

    @post_decorated = PostDecorator.new(@post)
    @about_decorated = PostDecorator.new(@about)
    @blog_decorated = PostDecorator.new(@blog)
    @blog_naked_decorated = PostDecorator.new(@blog_naked)
  end
end
