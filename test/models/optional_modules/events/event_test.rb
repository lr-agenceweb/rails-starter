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

  #
  # == Prev / Next
  #
  test 'should have a next record' do
    assert @event.next?, 'should have a next record'
    assert_equal @event.fetch_next.title, 'Evénement 3'
  end

  test 'should have a prev record' do
    assert @event_third.prev?, 'should have a prev record'
    assert_equal @event_third.fetch_prev.title, 'Evénement 1'
  end

  test 'should not have a prev record' do
    assert_not @event.prev?, 'should not have a prev record'
  end

  test 'should not have a next record' do
    assert_not @event_third.next?, 'should not have a next record'
  end

  private

  def initialize_test
    @event = events(:event_online)
    @event_third = events(:event_third)
  end
end
