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
    attrs = { id: SecureRandom.uuid, link_attributes: { url: 'bad-link' } }
    connection = set_connection_record(attrs)
    assert_not connection.valid?
    assert_equal [:'link.url'], connection.errors.keys
    connection.delete
  end

  test 'should create connection if link is correct' do
    attrs = { id: SecureRandom.uuid, link_attributes: { url: 'http://test.com' } }
    connection = set_connection_record(attrs)
    assert connection.valid?
    assert_empty connection.errors.keys
    connection.delete
  end

  def set_connection_record(attrs)
    connection = Connection.new attrs
    connection.set_translations(
      fr: { title: 'BarFoo' },
      en: { title: 'FooBar' }
    )
    connection
  end
end
