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

  test 'should return true if dates are corrects' do
    attrs = {
      start_date: Time.zone.now,
      end_date: Time.zone.now + 1.day.to_i
    }
    event = Event.new attrs
    assert event.calendar_date_correct?
  end

  test 'should return false if dates are not corrects' do
    attrs = {
      start_date: Time.zone.now + 1.day.to_i,
      end_date: Time.zone.now
    }
    event = Event.new attrs
    assert_equal [I18n.t('form.errors.end_date')], event.calendar_date_correct?
  end

  private

  def initialize_test
    @event = events(:event_online)
  end
end
