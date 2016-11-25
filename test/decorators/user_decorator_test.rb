# frozen_string_literal: true
require 'test_helper'

#
# UserDecorator test
# ====================
class UserDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # Avatar
  # ========
  test 'should return gravatar image if no avatar uploaded' do
    user_decorated = @administrator_decorated
    assert_equal gravatar_image_tag(@administrator.email, alt: @administrator.username, gravatar: { size: 64, secure: true }), user_decorated.image_avatar
  end

  test 'should return correct uploaded avatar' do
    user_decorated = UserDecorator.new(@subscriber)
    assert_equal retina_thumb_square(@subscriber), user_decorated.image_avatar
  end

  #
  # Admin link
  # ============
  test 'should return correct admin link' do
    user_decorated = @administrator_decorated
    assert_match '<a href="/admin/users/bob">Voir</a>', user_decorated.admin_link
  end

  test 'should return correct connected_from value' do
    expected = t('user.connected_from', from: 'site')
    assert_equal expected, @administrator_decorated.connected_from

    expected = t('user.connected_from', from: 'facebook')
    assert_equal expected, UserDecorator.new(@facebook_user).connected_from
  end

  #
  # ActiveAdmin
  # =============
  test 'should return correct html for header user profile' do
    expected = '<img alt="bob" src="https://secure.gravatar.com/avatar/124c4cfb97b3bd8b5678301071cc695f?default=mm&secure=true&size=64" width="64" height="64" /> <span>Bob (Administrateur)<br />Depuis site</span>'
    assert_equal expected, @administrator_decorated.active_admin_header_user_profile
  end

  #
  # Omniauth
  # ==========
  test 'should return correct link_to_facebook content if not yet linked' do
    user_decorated = UserDecorator.new(@subscriber)
    assert_equal "<a class=\"button omniauth facebook\" id=\"omniauth_facebook\" data-vex-title=\"#{I18n.t('omniauth.title', provider: 'Facebook')}\" data-vex-message=\"#{I18n.t('omniauth.link.message', provider: 'Facebook')}\" href=\"/admin/auth/facebook\"><i class=\"fa fa-facebook\"></i> Lier à mon compte Facebook</a>", user_decorated.link_to_facebook
  end

  test 'should return correct link_to_facebook content if linked' do
    user_decorated = UserDecorator.new(@facebook_user)
    assert_equal "<a class=\"button omniauth facebook\" id=\"omniauth_facebook\" data-vex-title=\"#{I18n.t('omniauth.title', provider: 'Facebook')}\" data-vex-message=\"#{I18n.t('omniauth.unlink.message', provider: 'Facebook')}\" rel=\"nofollow\" data-method=\"delete\" href=\"/admin/auth/#{@facebook_user.id}/facebook/unlink\"><i class=\"fa fa-facebook\"></i> Supprimer le lien avec mon compte Facebook</a>", user_decorated.link_to_facebook
  end

  #
  # Status tag
  # ============
  test 'should return correct status_tag for subscriber' do
    user_decorated = UserDecorator.new(@subscriber)
    assert_match '<span class="status_tag abonné green">Abonné</span>', user_decorated.status
  end

  test 'should return correct status_tag for administrator' do
    user_decorated = @administrator_decorated
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

    @administrator_decorated = UserDecorator.new(@administrator)
  end
end
