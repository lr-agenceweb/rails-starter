require 'test_helper'

#
# == Role model test
#
class RoleTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should return all roles list if super_administrator' do
    roles = Role.allowed_roles_for_user_role(@super_administrator)
    assert_equal roles.count, 3
    assert roles.exists?(name: 'subscriber')
    assert roles.exists?(name: 'administrator')
    assert roles.exists?(name: 'super_administrator')
  end

  test 'should return all roles list except super_administrator if administrator' do
    roles = Role.allowed_roles_for_user_role(@administrator)
    assert_equal roles.count, 2
    assert roles.exists?(name: 'administrator')
    assert roles.exists?(name: 'subscriber')
    assert_not roles.exists?(name: 'super_administrator')
  end

  test 'should return nil if subscriber' do
    roles = Role.allowed_roles_for_user_role(@subscriber)
    assert roles.nil?
  end

  private

  def initialize_test
    @super_administrator = users(:anthony)
    @administrator = users(:bob)
    @subscriber = users(:alice)
  end
end
