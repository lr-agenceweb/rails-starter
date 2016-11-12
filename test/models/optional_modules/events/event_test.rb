# frozen_string_literal: true
require 'test_helper'

#
# == Event model test
#
class EventTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  #
  # Validation rules
  # ===================
  test 'should not be valid if title is not filled' do
    attrs = { id: SecureRandom.random_number(1_000), start_date: Time.zone.now + 1.day, all_day: true }
    event = Event.new attrs

    refute event.valid?, 'should not be valid if title is not set'
    assert_equal [:"translations.title"], event.errors.keys
    event.delete
  end

  test 'should not be valid if start_date is not present' do
    attrs = { id: SecureRandom.random_number(1_000), all_day: true }
    event = define_event_record(attrs)

    assert_not event.valid?
    assert_equal [:start_date], event.errors.keys
    event.delete
  end

  test 'should not be valid if start_date finish after end_date' do
    attrs = { id: SecureRandom.random_number(1_000), start_date: Time.zone.now + 1.day, end_date: Time.zone.now }
    event = define_event_record(attrs)

    assert_not event.valid?
    assert_equal [:start_date, :end_date], event.errors.keys
    event.delete
  end

  test 'should not create event if link is not correct' do
    attrs = { id: SecureRandom.random_number(1_000), link_attributes: { url: 'bad-link' }, start_date: Time.zone.now, all_day: true }
    event = define_event_record(attrs)

    assert_not event.valid?
    assert_equal [:'link.url'], event.errors.keys
  end

  test 'should create event if link is correct' do
    attrs = { id: SecureRandom.random_number(1_000), link_attributes: { url: 'http://test.com' }, start_date: Time.zone.now, all_day: true }
    event = define_event_record(attrs)

    assert event.valid?
    assert_empty event.errors.keys
    event.delete
  end

  test 'should return correct columns name for event' do
    expected = {
      start_attr: 'start_date',
      end_attr: 'end_date'
    }
    assert_equal expected, Event.new.send(:klass_attrs)
  end

  #
  # Callback
  # ===========
  test 'should reset end_date if all_day is checked' do
    attrs = { id: SecureRandom.random_number(1_000), start_date: Time.zone.now, end_date: 2.days.from_now, all_day: true }
    event = define_event_record(attrs)

    assert event.valid?
    assert event.all_day?
    assert_nil event.end_date
  end

  test 'should check all_day if end_date is nil' do
    attrs = { id: SecureRandom.random_number(1_000), start_date: Time.zone.now }
    event = define_event_record(attrs)

    assert event.valid?
    assert event.all_day?
    assert_nil event.end_date
  end

  #
  # Misc
  # ============
  test 'should return correct duration for event' do
    assert_equal '6 jours', @event.decorate.duration
  end

  test 'should return true if dates are corrects' do
    attrs = {
      id: SecureRandom.random_number(1_000),
      start_date: Time.zone.now,
      end_date: Time.zone.now + 1.day.to_i
    }
    event = define_event_record(attrs)
    assert event.send(:date_constraints)
    event.delete
  end

  test 'should return false if dates are not corrects' do
    attrs = {
      id: SecureRandom.random_number(1_000),
      start_date: Time.zone.now + 1.day.to_i,
      end_date: Time.zone.now
    }
    scope = 'activerecord.errors.models.event.attributes'
    event = define_event_record(attrs)
    assert_equal [I18n.t('end_date', scope: scope)], event.send(:date_constraints)
    event.delete
  end

  test 'should return only current or coming events' do
    coc = Event.current_or_coming
    ['Evénement 4', 'Evénement 5'].each do |item|
      assert coc.map(&:title).include?(item), "\"#{item}\" should be in current or coming"
    end

    ['Evénement 1', 'Evénement 2'].each do |item|
      assert_not coc.map(&:title).include?(item), "\"#{item}\" should not be in current or coming"
    end
  end

  #
  # EventOrder
  # ===================
  test 'should return correct order if current_or_coming' do
    assert_equal 'Evénement 4', Event.with_conditions.first.title
  end

  test 'should return correct order if all are shown' do
    @event_setting.update_attribute(:event_order_id, @event_order_all.id)
    assert_equal 'Evénement 5', Event.with_conditions.first.title
  end

  #
  # Prev / Next
  # ===================
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
    assert_not @event_five.next?, 'should not have a next record'
  end

  #
  # Flash content
  # ===================
  test 'should not have flash content if no video are uploaded' do
    @event.save!
    assert @event.video_upload_flash_notice.blank?
  end

  test 'should return correct flash content after updating a video' do
    video = fixture_file_upload 'videos/test.mp4', 'video/mp4'
    @event.update_attributes(video_uploads_attributes: [{ video_file: video }, { video_file: video }])
    @event.save!
    assert_equal I18n.t('video_upload.flash.upload_in_progress'), @event.video_upload_flash_notice
  end

  #
  # Slug
  # ==========
  test 'should be valid if title is set properly' do
    event = Event.new(id: SecureRandom.random_number(1_000), start_date: Time.zone.now + 1.day, all_day: true)
    event.set_translations(
      fr: { title: 'Mon événement' },
      en: { title: 'My event' }
    )

    assert event.valid?, 'should be valid if title is set properly'
    assert_empty event.errors.keys

    I18n.with_locale('fr') do
      assert_equal 'Mon événement', event.title
      assert_equal 'mon-evenement', event.slug
    end
    I18n.with_locale('en') do
      assert_equal 'My event', event.title
      assert_equal 'my-event', event.slug
    end

    event.delete
  end

  test 'should add id to slug if slug already exists' do
    event = Event.new(id: SecureRandom.random_number(1_000), start_date: Time.zone.now + 1.day, all_day: true)
    event.set_translations(
      fr: { title: 'Evénement 1' },
      en: { title: 'Event 1' }
    )

    puts "=== === ==== #{event.title_changed?}"

    assert event.valid?, 'should be valid'
    assert_empty event.errors.keys
    assert_empty event.errors.messages

    I18n.with_locale('fr') do
      assert_equal 'evenement-1-2', event.slug
    end
    I18n.with_locale('en') do
      assert_equal 'event-1-2', event.slug
    end

    event.delete
  end

  private

  def initialize_test
    @event = events(:event_online)
    @event_third = events(:event_third)
    @event_five = events(:event_five)

    @event_order_coc = event_orders(:one)
    @event_order_all = event_orders(:two)
    @event_setting = event_settings(:one)
  end

  def define_event_record(attrs)
    event = Event.new attrs
    event.set_translations(
      fr: { title: 'BarFoo' },
      en: { title: 'FooBar' }
    )
    event
  end
end
