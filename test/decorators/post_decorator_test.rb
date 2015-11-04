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

  #
  # ActiveAdmin
  #
  test 'should return correct AA show page title' do
    assert_equal "Article lié à la page \"Accueil\"", @post_decorated.title_aa_show
  end

  private

  def initialize_test
    @post = posts(:home)
    @post_decorated = PostDecorator.new(@post)
  end
end
