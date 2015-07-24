require 'test_helper'

#
# == Event model test
#
class EventTest < ActiveSupport::TestCase
  test 'should return correct count for events' do
    assert_equal 3, Event.count
  end

  test 'should return correct count for online events' do
    assert_equal 2, Event.online.count
  end
end
