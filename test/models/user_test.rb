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

  test 'should save user if facebook omniauth doesn\'t exist' do
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
    assert_equal 'rafael', user.username
    assert_equal 'rafael', user.slug
    assert_equal 'rafael.nadal@test.com', user.email
    assert_not user.password.blank?
    assert_equal 'facebook', user.provider
    assert_equal 987_654_321.to_s, user.uid
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

    user = User.from_omniauth(@request.env['omniauth.auth'])
    assert_equal 'rafa 1357908642', user.username
    assert_equal 'rafa-1357908642', user.slug
  end

  test 'should not be valid if email already exists in database' do
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

    user = User.from_omniauth(@request.env['omniauth.auth'])
    assert_not user.valid?
    assert_equal [:email], user.errors.keys
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
