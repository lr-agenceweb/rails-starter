# frozen_string_literal: true
require 'test_helper'

#
# == Role model test
#
class RoleTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should return all roles list if SA' do
    roles = Role.allowed_roles_for_user_role(@super_administrator)
    assert_equal roles.count, 3
    assert roles.any? { |role| role.include?('Administrateur') }
    assert roles.any? { |role| role.include?('Abonné') }
    assert roles.any? { |role| role.include?('Super administrateur') }
  end

  test 'should return all roles list except SA if admin' do
    roles = Role.allowed_roles_for_user_role(@administrator)
    assert_equal roles.count, 2
    assert roles.any? { |role| role.include?('Administrateur') }
    assert roles.any? { |role| role.include?('Abonné') }
    assert_not roles.any? { |role| role.include?('Super administrateur') }
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
