
# frozen_string_literal: true
require 'test_helper'

#
# == EventDecorator test
#
class EventDecoratorTest < Draper::TestCase
  setup :initialize_test

  #
  # == Event URL
  #
  test 'should have a link for the event' do
    assert_match '<a target="_blank" href="http://www.google.com">http://www.google.com</a>', @event_decorated.link_with_link
  end

  test 'should not have a link for the event' do
    assert_not @event_two_decorated.link_with_link
  end

  test 'should return true for link? method if link' do
    assert @event_decorated.send(:link?)
  end

  test 'should return false for link? method if no link' do
    assert_not @event_two_decorated.send(:link?)
  end

  test 'should return false for link? method if link is empty' do
    @link.update_attributes! url: ''
    assert_not @event_two_decorated.send(:link?)
  end

  #
  # == Event dates
  #
  test 'should have start date for event' do
    assert @event_decorated.send(:start_date?)
  end

  test 'should have end date for event' do
    assert @event_decorated.send(:end_date?)
  end

  test 'should have correct duration for event dates' do
    assert_equal '6 jours', @event_decorated.duration
  end

  test 'should not have duration if all dates are not specified' do
    assert_nil @event_two_decorated.duration
  end

  test 'should have correct start_date html formatted' do
    assert_equal '<time datetime="2015-07-22T11:00:00+02:00">22/07</time>', @event_decorated.start_date_deco
  end

  test 'should have correct end_date html formatted' do
    assert_equal '<time datetime="2015-07-28T20:00:00+02:00">28/07/2015</time>', @event_decorated.end_date_deco
  end

  test 'should not have end_date if setting not specified' do
    assert_nil @event_two_decorated.end_date_deco
  end

  test 'should have correct from_to_date html formatted' do
    assert_equal 'Du <time datetime="2015-07-22T11:00:00+02:00">22/07</time> au <time datetime="2015-07-28T20:00:00+02:00">28/07/2015</time>', @event_decorated.from_to_date
  end

  test 'should have correct from_to_date html for all_day event' do
    assert_equal '<time datetime="2016-05-23T02:00:00+02:00">23/05/2016</time>', @event_all_day_decorated.from_to_date
  end

  test 'should return correct value for current_event? with all_day?' do
    local_time_1 = Time.zone.local(2016, 5, 23, 14, 0, 0)
    local_time_2 = Time.zone.local(2016, 5, 20, 14, 0, 0)
    local_time_3 = Time.zone.local(2016, 5, 26, 14, 0, 0)
    Timecop.freeze(local_time_1) do
      assert @event_all_day_decorated.current_event?
    end

    Timecop.freeze(local_time_2) do
      assert_not @event_all_day_decorated.current_event?
    end

    Timecop.freeze(local_time_3) do
      assert_not @event_all_day_decorated.current_event?
    end
  end

  test 'should return correct value for current_event? with start_date and end_date event' do
    local_time_1 = Time.zone.local(2015, 7, 25, 14, 0, 0)
    local_time_2 = Time.zone.local(2015, 7, 18, 14, 0, 0)
    local_time_3 = Time.zone.local(2015, 7, 30, 14, 0, 0)
    Timecop.freeze(local_time_1) do
      assert @event_decorated.current_event?
    end

    Timecop.freeze(local_time_2) do
      assert_not @event_decorated.current_event?
    end

    Timecop.freeze(local_time_3) do
      assert_not @event_decorated.current_event?
    end
  end

  #
  # == Calendar
  #
  test 'should return correct boolean value if show calendar' do
    assert_not @event_decorated.all_conditions_to_show_calendar?(@calendar_module)
    @event.update_attributes(show_calendar: true)
    assert @event_decorated.all_conditions_to_show_calendar?(@calendar_module)
    @calendar_module.update_attributes(enabled: false)
    assert_not @event_decorated.all_conditions_to_show_calendar?(@calendar_module)
  end

  #
  # == Map
  #
  test 'should return correct boolean value if show map' do
    # Map module enabled
    assert_not @event_decorated.all_conditions_to_show_map?(@map_module)

    # EventSetting show_map enabled
    @event_settings.update_attributes(show_map: true)
    assert_not @event_decorated.all_conditions_to_show_map?(@map_module)

    # Event show_map? enabled
    @event.update_attributes(show_map: true)
    assert @event_decorated.all_conditions_to_show_map?(@map_module)

    # Map module disabled
    @map_module.update_attributes(enabled: false)
    assert_not @event_decorated.all_conditions_to_show_map?(@map_module)
  end

  #
  # == Location
  #
  test 'should return correct boolean for location?' do
    assert @event_decorated.send(:location?)
    assert_not @event_two_decorated.send(:location?)
  end

  test 'should return correct html for full address' do
    assert_equal '<span>4 avenue de la chouette, 77700 - Gotham</span>', @event_decorated.full_address
    @event.location.update_attributes(address: '')
    assert_equal '<span>77700 - Gotham</span>', @event_decorated.full_address
    assert_nil @event_two_decorated.full_address
  end

  private

  def initialize_test
    @event = events(:event_online)
    @event_two = events(:event_third)
    @event_all_day = events(:all_day)
    @event_settings = event_settings(:one)

    @map_module = optional_modules(:map)
    @calendar_module = optional_modules(:calendar)

    @link = links(:event)

    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)

    @locales = I18n.available_locales
    @event_decorated = EventDecorator.new(@event)
    @event_two_decorated = EventDecorator.new(@event_two)
    @event_all_day_decorated = EventDecorator.new(@event_all_day)
  end
end
