require 'test_helper'

#
# == UserDecorator test
#
class UserDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # == Avatar
  #
  test 'should return gravatar image if not avatar uploaded' do
    user_decorated = UserDecorator.new(@administrator)
    assert_equal gravatar_image_tag(@administrator.email, alt: @administrator.username, gravatar: { size: @administrator.class.instance_variable_get(:@avatar_width) }), user_decorated.image_avatar
  end

  test 'should return correct uploaded avatar' do
    user_decorated = UserDecorator.new(@subscriber)
    assert_equal retina_thumb_square(@subscriber), user_decorated.image_avatar
  end

  #
  # == Admin link
  #
  test 'should return correct admin link' do
    user_decorated = UserDecorator.new(@administrator)
    assert_match "<a href=\"/admin/users/bob\">Voir</a>", user_decorated.admin_link
  end

  #
  # == Status tag
  #
  test 'should return correct status_tag for subscriber' do
    user_decorated = UserDecorator.new(@subscriber)
    assert_match "<span class=\"status_tag abonné green\">Abonné</span>", user_decorated.status
  end

  test 'should return correct status_tag for administrator' do
    user_decorated = UserDecorator.new(@administrator)
    assert_match "<span class=\"status_tag administrateur red\">Administrateur</span>", user_decorated.status
  end

  test 'should return correct status_tag for super_administrator' do
    user_decorated = UserDecorator.new(@super_administrator)
    assert_match "<span class=\"status_tag super_administrateur blue\">Super Administrateur</span>", user_decorated.status
  end

  private

  def initialize_test
    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)
  end
end
