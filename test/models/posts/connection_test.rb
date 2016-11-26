# frozen_string_literal: true
require 'test_helper'

#
# Connection Model test
# =======================
class ConnectionTest < ActiveSupport::TestCase
  #
  # Shoulda
  # =========
  should have_one(:link)
  should accept_nested_attributes_for(:link)

  #
  # Validation rules
  # ==================
  test 'should not create connection if link is not correct' do
    attrs = { id: SecureRandom.random_number(1_000), link_attributes: { url: 'bad-link' } }
    connection = define_connection_record(attrs)
    assert_not connection.valid?
    assert_equal [:'link.url'], connection.errors.keys
    connection.delete
  end

  test 'should create connection if link is correct' do
    attrs = { id: SecureRandom.random_number(1_000), link_attributes: { url: 'http://test.com' } }
    connection = define_connection_record(attrs)
    assert connection.valid?
    assert_empty connection.errors.keys
    connection.delete
  end

  def define_connection_record(attrs)
    connection = Connection.new attrs
    connection.set_translations(
      fr: { title: 'BarFoo' },
      en: { title: 'FooBar' }
    )
    connection
  end
end
