require 'test_helper'

#
# == PostDecorator test
#
class PostDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # Post informations
  #
  test 'should return correct author for post' do
    assert_equal 'bob', @post_decorated.author
  end

  test 'should return correct admin author url for post' do
    assert_equal "<a href=\"/admin/users/bob\">bob</a>", @post_decorated.link_author
  end

  test 'should return correct content' do
    assert_equal "<p>Premier article d'accueil</p>", @post_decorated.content
  end

  test 'should return correct page for post' do
    assert_equal 'Accueil', @post_decorated.type_title
  end

  test 'should return correct title link for home (show action)' do
    assert_equal "<a target=\"_blank\" href=\"/\">Article d'accueil</a>", @post_decorated.title_front_link
  end

  test 'should return correct title link for about (show action)' do
    @post_about_decorated = PostDecorator.new(@post_about)
    assert_equal "<a target=\"_blank\" href=\"/a-propos/developpement-hebergement\">Développement et Hébergement</a>", @post_about_decorated.title_front_link
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
    assert_equal "Article lié à la page \"Accueil\"", @post_decorated.title_aa_show
  end

  test 'should return correct admin_link for article' do
    assert_equal '<a href="/admin/abouts/developpement-hebergement">Voir</a>', @post_about_decorated.admin_link
  end

  #
  # == Status tag
  #
  test 'should return correct status_tag if comments enabled' do
    @post.update_attribute(:allow_comments, true)
    assert_match "<span class=\"status_tag commentaires_autorisés green\">Commentaires Autorisés</span>", @post_decorated.allow_comments_status
  end

  test 'should return correct status_tag if comments disabled' do
    @post.update_attribute(:allow_comments, false)
    assert_match "<span class=\"status_tag article_non_commentable red\">Article Non Commentable</span>", @post_decorated.allow_comments_status
  end

  private

  def initialize_test
    @post = posts(:home)
    @post_about = posts(:about)
    @post_about_2 = posts(:about_2)
    @post_decorated = PostDecorator.new(@post)
    @post_about_decorated = PostDecorator.new(@post_about)
  end
end
