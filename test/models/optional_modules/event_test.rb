require 'test_helper'

#
# == Event model test
#
class EventTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should return correct count for events' do
    assert_equal 3, Event.count
  end

  test 'should return correct count for online events' do
    assert_equal 2, Event.online.count
  end

  test 'should return correct duration for event' do
    assert_equal '6 jours', @event.decorate.duration
  end

  private

  def initialize_test
    @event = events(:event_online)
  end
end
