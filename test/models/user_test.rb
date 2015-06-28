require 'test_helper'

#
# == User model test
#
class UserTest < ActiveSupport::TestCase
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
    assert @super_administrator.avatar?
  end

  test 'should be false if user avatar is nil' do
    assert_not @guest.avatar?
  end

  private

  def initialize_test
    @super_administrator = users(:anthony)
    @administrator = users(:bob)
    @subscriber = users(:alice)
    @guest = users(:lana)
  end
end
