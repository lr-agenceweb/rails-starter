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
  test 'should be true if user avatar is present' do
    assert_equal 'bart.jpg', @guest.avatar_file_name
    assert_not @guest.avatar?
  end

  test 'should be false if user avatar is nil' do
    assert_not @super_administrator.avatar?
  end

  test 'should not upload avatar if mime type is not allowed' do
    assert_nil @subscriber.avatar.path(:original)
    assert_nil @subscriber.avatar.path(:large)
    assert_nil @subscriber.avatar.path(:medium)
    assert_nil @subscriber.avatar.path(:small)
    assert_nil @subscriber.avatar.path(:thumb)

    attachment = fixture_file_upload 'images/fake.txt', 'text/plain'
    @subscriber.update_attributes(avatar: attachment)

    assert_not_processed 'fake.txt', :original, @subscriber.avatar
    assert_not_processed 'fake.txt', :large, @subscriber.avatar
    assert_not_processed 'fake.txt', :medium, @subscriber.avatar
    assert_not_processed 'fake.txt', :small, @subscriber.avatar
    assert_not_processed 'fake.txt', :thumb, @subscriber.avatar
  end

  test 'should upload avatar if mime type is allowed' do
    assert_nil @subscriber.avatar.path(:original)
    assert_nil @subscriber.avatar.path(:large)
    assert_nil @subscriber.avatar.path(:medium)
    assert_nil @subscriber.avatar.path(:small)
    assert_nil @subscriber.avatar.path(:thumb)

    attachment = fixture_file_upload 'images/bart.png', 'image/png'
    @subscriber.update_attributes!(avatar: attachment)

    assert_processed 'bart.png', :original, @subscriber.avatar
    assert_processed 'bart.png', :large, @subscriber.avatar
    assert_processed 'bart.png', :medium, @subscriber.avatar
    assert_processed 'bart.png', :small, @subscriber.avatar
    assert_processed 'bart.png', :thumb, @subscriber.avatar
  end

  private

  def initialize_test
    @super_administrator = users(:anthony)
    @administrator = users(:bob)
    @subscriber = users(:alice)
    @guest = users(:lana)
  end
end
