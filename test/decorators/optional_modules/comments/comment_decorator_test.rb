# frozen_string_literal: true
require 'test_helper'

#
# == CommentDecorator test
#
class CommentDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers
  include ActionDispatch::TestProcess

  setup :initialize_test

  #
  # == Pseudo and Email
  #
  test 'should return correct name if user is connected' do
    assert_equal 'Anthony', @comment_decorated.pseudo_registered_or_guest
  end

  test 'should return correct name if user is not connected' do
    comment_decorated = CommentDecorator.new(@comment_not_connected)
    assert_equal 'Luke', comment_decorated.pseudo_registered_or_guest
  end

  test 'should return correct html_tag for user' do
    assert_equal '<strong class="comment__author__name">Anthony</strong>', @comment_decorated.pseudo
  end

  test 'should return correct email if user is connected' do
    assert_equal 'anthony@test.fr', @comment_decorated.email_registered_or_guest
  end

  test 'should return correct email if user is not connected' do
    comment_decorated = CommentDecorator.new(@comment_not_connected)
    assert_equal 'luke@skywalker.sw', comment_decorated.email_registered_or_guest
  end

  #
  # == Avatar
  #
  test 'should return correct avatar for connected user' do
    assert_equal '<img alt="anthony" src="https://secure.gravatar.com/avatar/d7097d5b6b00db57b0bf772923729a7d?default=mm&secure=true" width="80" height="80" />', @comment_decorated.avatar
  end

  test 'should return correct avatar for guest user' do
    comment_decorated = CommentDecorator.new(@comment_not_connected)
    assert_equal '<img alt="luke" src="https://secure.gravatar.com/avatar/2e5c8c61be4beb99af2f3c5fbb77e988?default=mm&secure=true" width="80" height="80" />', comment_decorated.avatar
  end

  test 'should return correct author with avatar' do
    comment_decorated = CommentDecorator.new(@comment_not_connected)
    assert_equal '<div class="author-with-avatar"><img alt="luke" src="https://secure.gravatar.com/avatar/2e5c8c61be4beb99af2f3c5fbb77e988?default=mm&secure=true" width="80" height="80" /> <br /> Luke</div>', comment_decorated.author_with_avatar
  end

  #
  # == Content
  #
  test 'should return preview of comment' do
    assert_equal 'Mon commentaire de test', @comment_decorated.preview_content

    @comment_decorated.update_attribute(:comment, 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
    assert_equal 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut...', @comment_decorated.preview_content
  end

  #
  # == Commentable
  #
  test 'should return correct commentable_path' do
    assert_equal '/a-propos/article-2-a-propos', @comment_decorated.commentable_path
    assert_equal '/blogs/foo/article-de-blog-en-ligne', @blog_comment_decorated.commentable_path
  end

  test 'should return correct commentable link for regular articles' do
    assert_equal "<a target=\"_blank\" class=\"button\" href=\"/a-propos/article-2-a-propos\">Article 2 A Propos <br /> (#{I18n.t('comment.admin.go_to_source')})</a>", @comment_decorated.link_source
  end

  test 'should return correct commentable link for blog articles' do
    assert_equal "<a target=\"_blank\" class=\"button\" href=\"/blogs/foo/article-de-blog-en-ligne\">Article de blog en ligne <br /> (#{I18n.t('comment.admin.go_to_source')})</a>", @blog_comment_decorated.link_source
  end

  test 'should return correct commentable link and image' do
    @blog_comment.commentable.pictures.each(&:destroy)

    attachment = fixture_file_upload 'images/bart.png', 'image/png'
    Picture.create(attachable_id: @blog_comment.commentable_id, attachable_type: 'Blog', image: attachment)
    assert_equal "<p><img width=\"125\" height=\"223\" src=\"#{@blog_comment.commentable.picture.image.url(:medium)}\" alt=\"Medium bart\" /> <br /> <a target=\"_blank\" class=\"button\" href=\"/blogs/foo/article-de-blog-en-ligne\">Article de blog en ligne <br /> (#{I18n.t('comment.admin.go_to_source')})</a></p>", @blog_comment_decorated.link_and_image_source
  end

  private

  def initialize_test
    @comment = comments(:one)
    @blog_comment = comments(:blog)
    @comment_not_connected = comments(:five)

    @comment_decorated = CommentDecorator.new(@comment)
    @blog_comment_decorated = CommentDecorator.new(@blog_comment)
  end
end
