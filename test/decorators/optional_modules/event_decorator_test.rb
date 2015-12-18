
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
    assert_match '<a target="_blank" href="http://google.com">http://google.com</a>', @event_decorated.url
  end

  test 'should not have a link for the event' do
    assert_match 'Pas de lien', @event_two_decorated.url
  end

  test 'should return true for url? method if link' do
    assert @event_decorated.send(:url?)
  end

  test 'should return false for url? method if no link' do
    assert_not @event_two_decorated.send(:url?)
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
    assert_equal '<time datetime="2015-07-22T09:00:00+02:00">mercredi 22 juillet</time>', @event_decorated.start_date_deco
  end

  test 'should have correct end_date html formatted' do
    assert_equal '<time datetime="2015-07-28T18:00:00+02:00">mardi 28 juillet 2015</time>', @event_decorated.end_date_deco
  end

  test 'should not have end_date if setting not specified' do
    assert_nil @event_two_decorated.end_date_deco
  end

  test 'should have correct from_to_date html formatted' do
    assert_equal 'Du <time datetime="2015-07-22T09:00:00+02:00">mercredi 22 juillet</time> au <time datetime="2015-07-28T18:00:00+02:00">mardi 28 juillet 2015</time>', @event_decorated.from_to_date
  end

  test 'should not return from_to_date if start or end not set' do
    assert_nil @event_two_decorated.from_to_date
  end

  #
  # == Calendar
  #
  test 'should return correct status_tag for show_calendar' do
    assert_match "<span class=\"status_tag désactivé red\">Désactivé</span>", @event_decorated.show_calendar_d
    @event.update_attributes(show_calendar: true)
    assert_match "<span class=\"status_tag activé green\">Activé</span>", @event_decorated.show_calendar_d
  end

  test 'should return correct boolean value if show calendar' do
    assert_not @event_decorated.all_conditions_to_show_calendar?(@calendar_module)
    @event.update_attributes(show_calendar: true)
    assert @event_decorated.all_conditions_to_show_calendar?(@calendar_module)
    @calendar_module.update_attributes(enabled: false)
    assert_not @event_decorated.all_conditions_to_show_calendar?(@calendar_module)
  end

  #
  # == Location
  #
  test 'should return correct boolean for location?' do
    assert @event_decorated.send(:location?)
    assert_not @event_two_decorated.send(:location?)
  end

  test 'should return correct html for full address' do
    assert_equal '<span>4 avenue de la chouette, 77700 - Gotham</span>', @event_decorated.full_address_inline
    @event.location.update_attributes(address: '')
    assert_equal '<span>77700 - Gotham</span>', @event_decorated.full_address_inline
    assert_nil @event_two_decorated.full_address_inline
  end

  private

  def initialize_test
    @event = events(:event_online)
    @event_two = events(:event_third)
    @calendar_module = optional_modules(:calendar)

    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)

    @locales = I18n.available_locales
    @event_decorated = EventDecorator.new(@event)
    @event_two_decorated = EventDecorator.new(@event_two)
  end
end
