# frozen_string_literal: true
require 'test_helper'

#
# User Model test
# =================
class UserTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  # Constants
  SIZE_PLUS_1 = User::ATTACHMENT_MAX_SIZE + 1

  #
  # Shoulda
  # =========
  should belong_to(:role)
  should have_many(:posts)
  should have_many(:blogs)

  should validate_presence_of(:username)
    .with_message(I18n.t('errors.attributes.username.blank'))
  should validate_presence_of(:email)
    .with_message(I18n.t('errors.attributes.email.blank'))

  should validate_uniqueness_of(:username)
    .with_message(I18n.t('errors.messages.taken'))
  should validate_uniqueness_of(:email)
    .with_message(I18n.t('errors.attributes.email.taken'))

  should allow_value('lorem@ipsum.com').for(:email)
  should_not allow_value('loremipsum.com').for(:email)
    .with_message(I18n.t('errors.attributes.email.email'))

  should accept_nested_attributes_for(:role)

  should have_attached_file(:avatar)
  should_not validate_attachment_presence(:avatar)
  should validate_attachment_content_type(:avatar)
    .allowing('image/jpg', 'image/png')
    .rejecting('text/plain', 'text/xml')
  should validate_attachment_size(:avatar)
    .less_than((SIZE_PLUS_1 - 1).megabytes)

  #
  # Roles
  # =======
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
  # Avatar
  # ========
  test 'should be true if user avatar is present with file' do
    avatar = fixture_file_upload 'images/bart.png'
    @subscriber.update_attribute(:avatar, avatar)
    assert @subscriber.avatar?
    assert_equal 'bart.png', @subscriber.avatar_file_name
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
  # Omniauth
  # ==========
  test 'should return correct from_omniauth? value' do
    assert @facebook_user.from_omniauth?
    assert_not @super_administrator.from_omniauth?
  end

  test 'should return nil if omniauth user doesn\'t exist' do
    set_base_request_for_omniauth(987_654_321, 'rafael', 'rafael.nadal@test.com')

    user = User.get_by_provider_and_uid(@request.env['omniauth.auth'])
    assert user.nil?
  end

  test 'should return user if facebook omniauth exists' do
    set_base_request_for_omniauth(123_456_789, 'rafa', 'rafa@nadal.es')

    user = User.get_by_provider_and_uid(@request.env['omniauth.auth'])
    assert_equal 'rafa', user.username
    assert_equal 'rafa', user.slug
    assert_equal 'rafa@nadal.es', user.email
    assert_equal 'facebook', user.provider
    assert_equal 123_456_789.to_s, user.uid
    assert_not user.avatar?, 'should not have avatar'
  end

  test 'should use name with uid if name already exists' do
    set_base_request_for_omniauth(1_357_908_642, 'rafa', 'rafael.nadal@test.com')

    user = @super_administrator.link_with_omniauth(@request.env['omniauth.auth'])
    assert_equal 'rafa 1357908642', user.username
    assert_equal 'rafa-1357908642', user.slug
  end

  test 'should not update name if connect twice as same user' do
    set_base_request_for_omniauth(1_357_908_642, 'rafa', 'rafael.nadal@test.com')

    user = @facebook_user.link_with_omniauth(@request.env['omniauth.auth'])
    assert_equal 'rafa', user.username
    assert_equal 'rafa', user.slug
    user = @facebook_user.link_with_omniauth(@request.env['omniauth.auth'])
    assert_equal 'rafa', user.username
    assert_equal 'rafa', user.slug
  end

  test 'should update name from facebook if it changed after linking account' do
    set_base_request_for_omniauth(1_357_908_642, 'Rafael Nadal', 'rafa@nadal.es')

    user = @facebook_user.link_with_omniauth(@request.env['omniauth.auth'])
    assert_equal 'Rafael Nadal', user.username
    assert_equal 'rafael-nadal', user.slug
    assert user.avatar_file_name.nil?
  end

  test 'should not be valid if omniauth email is not the same as classic account email' do
    set_base_request_for_omniauth(1_357_908_642, 'rafael', 'rafael.nadal@test.com')

    errors = User.check_for_errors(@request.env['omniauth.auth'], @super_administrator)
    assert_not errors.empty?
    assert errors[:already_linked].blank?
    assert I18n.t('omniauth.email.not_match', provider: 'facebook'), errors[:wrong_email]
  end

  test 'should be valid if omniauth email is not the same as classic account email on twitter' do
    set_base_request_for_omniauth(1_357_908_642, 'rafael', 'rafael.nadal@test.com', 'twitter')

    errors = User.check_for_errors(@request.env['omniauth.auth'], @super_administrator)
    assert errors.empty?
  end

  test 'should not be valid if user has already his account linked to facebook' do
    set_base_request_for_omniauth(1_357_908_642, 'rafael', 'rafa@nadal.es')

    errors = User.check_for_errors(@request.env['omniauth.auth'], @facebook_user)
    assert_not errors.empty?
    assert errors[:wrong_email].blank?
    assert I18n.t('omniauth.email.not_match', provider: 'facebook'), errors[:already_linked]
  end

  test 'should update omniauth info after logged in if changes' do
    set_base_request_for_omniauth(1_357_908_642, 'Rafael Nadal', 'rafa@nadal.es')
    OmniAuth.config.mock_auth[:facebook]['info']['image'] = 'http://www.gravatar.com/avatar/00000000000000000000000000000000'

    @facebook_user.update_infos_since_last_connection(@request.env['omniauth.auth'])
    assert_equal 'Rafael Nadal', @facebook_user.username
    assert_equal 'rafael-nadal', @facebook_user.slug
    assert_equal '00000000000000000000000000000000.jpg', @facebook_user.avatar_file_name
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

  def set_base_request_for_omniauth(id, name, email, provider = 'facebook')
    @request = ActionController::TestRequest.create
    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: provider,
      uid: id,
      info: {
        name: name,
        email: email
      }
    )

    @request.env['devise.mapping'] = Devise.mappings[:user]
    @request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
  end
end
