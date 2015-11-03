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
    assert @subscriber.avatar?
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

  test 'should count users' do
    assert_equal User.count, 6
  end

  private

  def initialize_test
    @super_administrator = users(:anthony)
    @administrator = users(:bob)
    @subscriber = users(:alice)
    @guest = users(:lana)
  end
end
