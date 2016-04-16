# frozen_string_literal: true
require 'test_helper'

#
# == Event model test
#
class EventTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  # test 'should return correct count for events' do
  #   assert_equal 3, Event.count
  # end

  # test 'should return correct count for online events' do
  #   assert_equal 2, Event.online.count
  # end

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
  # == EventOrder
  #
  test 'should return correct order if current_or_coming' do
    assert_equal 'Evénement 3', Event.with_conditions.first.title
  end

  test 'should return correct order if all are shown' do
    @event_setting.update_attribute(:event_order_id, @event_order_all.id)
    assert_equal 'Evénement 5', Event.with_conditions.first.title
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
    assert_not @event_five.next?, 'should not have a next record'
  end

  #
  # == Flash content
  #
  test 'should not have flash content if no video are uploaded' do
    @event.save!
    assert @event.flash_notice.blank?
  end

  test 'should return correct flash content after updating a video' do
    video = fixture_file_upload 'videos/test.mp4', 'video/mp4'
    @event.update_attributes(video_uploads_attributes: [{ video_file: video }, { video_file: video }])
    @event.save!
    assert_equal I18n.t('video_upload.flash.upload_in_progress'), @event.flash_notice
  end

  #
  # == Validation rules
  #
  test 'should not create event if link is not correct' do
    event = Event.new link_attributes: { url: 'bad-link' }
    assert_not event.valid?
    assert_equal [:'link.url'], event.errors.keys
  end

  test 'should create event if link is correct' do
    event = Event.new link_attributes: { url: 'http://test.com' }
    assert event.valid?
    assert_empty event.errors.keys
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
end
