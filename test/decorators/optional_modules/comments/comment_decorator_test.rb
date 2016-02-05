require 'test_helper'

#
# == CommentDecorator test
#
class CommentDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

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
    assert_equal "<img alt=\"anthony\" src=\"http://gravatar.com/avatar/d7097d5b6b00db57b0bf772923729a7d?secure=false\" width=\"80\" height=\"80\" />", @comment_decorated.avatar
  end

  test 'should return correct avatar for guest user' do
    comment_decorated = CommentDecorator.new(@comment_not_connected)
    assert_equal "<img alt=\"luke\" src=\"http://gravatar.com/avatar/2e5c8c61be4beb99af2f3c5fbb77e988?secure=false\" width=\"80\" height=\"80\" />", comment_decorated.avatar
  end

  test 'should return correct author with avatar' do
    comment_decorated = CommentDecorator.new(@comment_not_connected)
    assert_equal "<div class=\"author-with-avatar\"><img alt=\"luke\" src=\"http://gravatar.com/avatar/2e5c8c61be4beb99af2f3c5fbb77e988?secure=false\" width=\"80\" height=\"80\" /> <br /> Luke</div>", comment_decorated.author_with_avatar
  end

  #
  # == Date
  #
  test 'should return correct date of creation for comment' do
    assert_equal '<small><time datetime="2016-01-30T13:54:20+01:00">samedi 30 janvier 2016</time></small>', @comment_decorated.comment_created_at
  end

  #
  # == Status tag
  #
  test 'should return correct status_tag when validated' do
    assert_match "<span class=\"status_tag validé green\">Validé</span>", @comment_decorated.status
  end

  test 'should return correct status_tag when not validated' do
    @comment.update_attribute(:validated, false)
    assert_match "<span class=\"status_tag non_validé orange\">Non Validé</span>", @comment_decorated.status
  end

  test 'should return correct status_tag when not signalled' do
    assert_match "<span class=\"status_tag non green\">Non</span>", @comment_decorated.signalled_d
  end

  test 'should return correct status_tag when signalled' do
    @comment.update_attribute(:signalled, true)
    assert_match "<span class=\"status_tag oui red\">Oui</span>", @comment_decorated.signalled_d
  end

  private

  def initialize_test
    @comment = comments(:one)
    @comment_not_connected = comments(:five)
    @comment_decorated = CommentDecorator.new(@comment)
  end
end
