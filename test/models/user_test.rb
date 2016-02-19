require 'test_helper'

#
# == User model test
#
class UserTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  #
  # == Roles
  #
  test 'should be true if user is super_administrator' do
    assert @super_administrator.super_administrator?
  end

  test 'should be true if user is administrator' do
    assert @administrator.administrator?
  end

  test 'should be true if user is subscriber' do
    assert @subscriber.subscriber?
  end

  #
  # == Avatar
  #
  test 'should be true if user avatar is present with file' do
    assert_equal 'bart.png', @subscriber.avatar_file_name
    # assert @subscriber.avatar? # Not working with travis
  end

  test 'should be false if user avatar is present without file' do
    assert_equal 'bart.jpg', @guest.avatar_file_name
    assert_not @guest.avatar?
  end

  test 'should be false if user avatar is nil' do
    assert_not @super_administrator.avatar?
  end

  test 'should not upload avatar if mime type is not allowed' do
    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_nil @administrator.avatar.path(size)
    end

    attachment = fixture_file_upload 'images/fake.txt', 'text/plain'
    @administrator.update_attributes(avatar: attachment)

    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_not_processed 'fake.txt', size, @administrator.avatar
    end
  end

  test 'should upload avatar if mime type is allowed' do
    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_nil @administrator.avatar.path(size)
    end

    attachment = fixture_file_upload 'images/bart.png', 'image/png'
    @administrator.update_attributes!(avatar: attachment)

    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_processed 'bart.png', size, @administrator.avatar
    end
  end

  #
  # == Omniauth
  #
  test 'should return correct from_omniauth? value' do
    assert @facebook_user.from_omniauth?
    assert_not @super_administrator.from_omniauth?
  end

  test 'should return nil if omniauth user doesn\'t exist' do
    @request = ActionController::TestRequest.new

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: 987_654_321,
      info: {
        name: 'rafael',
        email: 'rafael.nadal@test.com'
      }
    )

    @request.env['devise.mapping'] = Devise.mappings[:user]
    @request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]

    user = User.from_omniauth(@request.env['omniauth.auth'])
    assert user.nil?
  end

  test 'should return user if facebook omniauth exists' do
    @request = ActionController::TestRequest.new

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: 123_456_789,
      info: {
        name: 'rafa',
        email: 'rafa@nadal.es'
      }
    )

    @request.env['devise.mapping'] = Devise.mappings[:user]
    @request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]

    user = User.from_omniauth(@request.env['omniauth.auth'])
    assert_equal 'rafa', user.username
    assert_equal 'rafa', user.slug
    assert_equal 'rafa@nadal.es', user.email
    assert_equal 'facebook', user.provider
    assert_equal 123_456_789.to_s, user.uid
    assert_not user.avatar?, 'should not have avatar'
  end

  test 'should use name with uid if name already exists' do
    @request = ActionController::TestRequest.new

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: 1_357_908_642,
      info: {
        name: 'rafa',
        email: 'rafael.nadal@test.com'
      }
    )

    @request.env['devise.mapping'] = Devise.mappings[:user]
    @request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]

    user = User.link_with_omniauth(@request.env['omniauth.auth'], @super_administrator)
    assert_equal 'rafa 1357908642', user.username
    assert_equal 'rafa-1357908642', user.slug
  end

  test 'should not update name if connect twice as same user' do
    @request = ActionController::TestRequest.new

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: 1_357_908_642,
      info: {
        name: 'rafa',
        email: 'rafael.nadal@test.com'
      }
    )

    @request.env['devise.mapping'] = Devise.mappings[:user]
    @request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]

    user = User.link_with_omniauth(@request.env['omniauth.auth'], @facebook_user)
    assert_equal 'rafa', user.username
    assert_equal 'rafa', user.slug
    user = User.link_with_omniauth(@request.env['omniauth.auth'], @facebook_user)
    assert_equal 'rafa', user.username
    assert_equal 'rafa', user.slug
  end

  test 'should update name from facebook if it changed after linking account' do
    @request = ActionController::TestRequest.new

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: 1_357_908_642,
      info: {
        name: 'Rafael Nadal',
        email: 'rafa@nadal.es'
      }
    )

    @request.env['devise.mapping'] = Devise.mappings[:user]
    @request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]

    user = User.link_with_omniauth(@request.env['omniauth.auth'], @facebook_user)
    assert_equal 'Rafael Nadal', user.username
    assert_equal 'rafael-nadal', user.slug
  end

  test 'should not be valid if omniauth email is not the same as classic account email' do
    @request = ActionController::TestRequest.new

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: 1_357_908_642,
      info: {
        name: 'rafael',
        email: 'rafael.nadal@test.com'
      }
    )

    @request.env['devise.mapping'] = Devise.mappings[:user]
    @request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]

    errors = User.check_for_errors(@request.env['omniauth.auth'], @super_administrator)
    assert_not errors.empty?
    assert errors[:already_linked].blank?
    assert I18n.t('omniauth.email.not_match', provider: 'facebook'), errors[:wrong_email]
  end

  test 'should not be valid if user has already is account linked to facebook' do
    @request = ActionController::TestRequest.new

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: 1_357_908_642,
      info: {
        name: 'rafael',
        email: 'rafa@nadal.es'
      }
    )

    @request.env['devise.mapping'] = Devise.mappings[:user]
    @request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]

    errors = User.check_for_errors(@request.env['omniauth.auth'], @facebook_user)
    assert_not errors.empty?
    assert errors[:wrong_email].blank?
    assert I18n.t('omniauth.email.not_match', provider: 'facebook'), errors[:already_linked]
  end

  private

  def initialize_test
    @super_administrator = users(:anthony)
    @administrator = users(:bob)
    @subscriber = users(:alice)
    @guest = users(:lana)

    @facebook_user = users(:rafa)

    OmniAuth.config.mock_auth[:twitter] = nil
  end
end
