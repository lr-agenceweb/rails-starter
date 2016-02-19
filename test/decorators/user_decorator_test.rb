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
  test 'should return gravatar image if no avatar uploaded' do
    user_decorated = UserDecorator.new(@administrator)
    assert_equal gravatar_image_tag(@administrator.email, alt: @administrator.username, gravatar: { size: 64 }), user_decorated.image_avatar
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
    assert_match '<a href="/admin/users/bob">Voir</a>', user_decorated.admin_link
  end

  #
  # == Omniauth
  #
  test 'should return correct link_to_facebook content if not yet linked' do
    user_decorated = UserDecorator.new(@subscriber)
    assert_equal '<a class="button omniauth facebook" id="omniauth_facebook" href="/admin/auth/facebook"><i class="fa fa-facebook"></i> Lier à mon compte Facebook</a>', user_decorated.link_to_facebook
  end

  test 'should return correct link_to_facebook content if linked' do
    user_decorated = UserDecorator.new(@facebook_user)
    assert_equal '<a class="button omniauth facebook" id="omniauth_facebook" href="/admin/auth/facebook?option=unlink"><i class="fa fa-facebook"></i> Supprimer le lien avec mon compte Facebook</a>', user_decorated.link_to_facebook
  end

  #
  # == Status tag
  #
  test 'should return correct status_tag for subscriber' do
    user_decorated = UserDecorator.new(@subscriber)
    assert_match '<span class="status_tag abonné green">Abonné</span>', user_decorated.status
  end

  test 'should return correct status_tag for administrator' do
    user_decorated = UserDecorator.new(@administrator)
    assert_match '<span class="status_tag administrateur red">Administrateur</span>', user_decorated.status
  end

  test 'should return correct status_tag for super_administrator' do
    user_decorated = UserDecorator.new(@super_administrator)
    assert_match '<span class="status_tag super_administrateur blue">Super Administrateur</span>', user_decorated.status
  end

  private

  def initialize_test
    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)
    @facebook_user = users(:rafa)
  end
end
