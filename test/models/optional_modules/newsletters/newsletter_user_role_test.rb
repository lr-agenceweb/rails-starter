# frozen_string_literal: true
require 'test_helper'

#
# == NewsletterUserRole test
#
class NewsletterUserRoleTest < ActiveSupport::TestCase
  test 'should not save if all good' do
    nur = NewsletterUserRole.new(kind: 'tester')
    assert nur.valid?
    assert nur.errors.keys.empty?
  end

  test 'should not save if kind is not set' do
    nur = NewsletterUserRole.new(kind: 'bad_value')
    assert_not nur.valid?
    assert_equal [:kind], nur.errors.keys
  end

  test 'should not save if kind is not allowed' do
    nur = NewsletterUserRole.new(kind: 'bad_value')
    assert_not nur.valid?
    assert_equal [:kind], nur.errors.keys
  end
end
