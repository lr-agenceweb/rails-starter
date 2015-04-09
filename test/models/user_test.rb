require 'test_helper'

#
# == User model test
#
class UserTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should be true if user is super_administrator' do
    assert @super_administrator.super_administrator?
  end

  test 'should be true if user is administrator' do
    assert @administrator.administrator?
  end

  test 'should be true if user is subscriber' do
    assert @subscriber.subscriber?
  end

  private

  def initialize_test
    @super_administrator = users(:anthony)
    @administrator = users(:bob)
    @subscriber = users(:alice)
  end
end
