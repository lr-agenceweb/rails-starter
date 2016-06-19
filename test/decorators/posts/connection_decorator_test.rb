# frozen_string_literal: true
require 'test_helper'

#
# == ConnectionDecorator test
#
class ConnectionDecoratorTest < Draper::TestCase
  setup :initialize_test

  test 'should have link is url is correct' do
    assert @connection_decorated.send(:link?)
  end

  test 'should not have link if url is empty' do
    @link.update_attributes! url: ''
    assert_not @connection_decorated.send(:link?)
  end

  test 'should return correct content for link method' do
    assert_equal '<a target="_blank" href="http://www.google.com">http://www.google.com</a>', @connection_decorated.link_with_link
  end

  private

  def initialize_test
    @link = links(:connection)
    @connection = posts(:connection)
    @connection_decorated = ConnectionDecorator.new(@connection)
  end
end
