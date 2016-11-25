# frozen_string_literal: true
require 'test_helper'

#
# == UserHelper Test
#
class UserHelperTest < ActionView::TestCase
  include Devise::Test::ControllerHelpers

  test 'should return true if user is super_administrator' do
    @super_administrator = users(:anthony)
    sign_in @super_administrator
    assert current_user_and_administrator?(@super_administrator)
  end

  test 'should return true if user is administrator' do
    @administrator = users(:bob)
    sign_in @administrator
    assert current_user_and_administrator?(@administrator)
  end

  test 'should return false if user is subscriber' do
    @subscriber = users(:alice)
    sign_in @subscriber
    assert_not current_user_and_administrator?(@subscriber)
  end
end
