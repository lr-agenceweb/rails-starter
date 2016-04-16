# frozen_string_literal: true
require 'test_helper'

#
# == Connection model test
#
class ConnectionTest < ActiveSupport::TestCase
  #
  # == Validation rules
  #
  test 'should not create connection if link is not correct' do
    connection = Connection.new link_attributes: { url: 'bad-link' }
    assert_not connection.valid?
    assert_equal [:'link.url'], connection.errors.keys
  end

  test 'should create connection if link is correct' do
    connection = Connection.new link_attributes: { url: 'http://test.com' }
    assert connection.valid?
    assert_empty connection.errors.keys
  end
end
