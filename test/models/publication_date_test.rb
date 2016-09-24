# frozen_string_literal: true
require 'test_helper'

#
# == PublicationDate Model test
#
class PublicationDateTest < ActiveSupport::TestCase
  setup :initialize_test

  #
  # == Published later / Expired prematurely
  #
  test 'should reset published_at to null if boolean is not checked' do
    assert_equal '2028-03-11 09:00:00', @published_later.published_at.to_s(:db)
    @published_later.update_attribute(:published_later, false)
    assert_nil @published_later.published_at
  end

  test 'should reset expired_at to null if boolean is not checked' do
    assert_equal '2028-12-27 21:00:00', @published_later.expired_at.to_s(:db)
    @published_later.update_attribute(:expired_prematurely, false)
    assert_nil @published_later.expired_at
  end

  test 'should not reset published_at / expired_at if boolean still checked' do
    @published_later.save
    assert_not_nil @published_later.expired_at
    assert_not_nil @published_later.published_at
  end

  #
  # Validation rules
  # ===================
  # Presence
  test 'should not be valid if published_later? is checked but not date is set' do
    @published_later.update_attributes(published_later: true, published_at: nil)
    assert_not @published_later.valid?
    assert_equal [:published_at], @published_later.errors.keys
  end

  test 'should not be valid if expired_prematurely? is checked but not date is set' do
    @published_later.update_attributes(expired_prematurely: true, expired_at: nil)
    assert_not @published_later.valid?
    assert_equal [:expired_at], @published_later.errors.keys
  end

  test 'should be valid if published_at is set but not expired_at' do
    @published_later.update_attribute(:expired_prematurely, false)
    assert @published_later.valid?
    assert_empty @published_later.errors.keys
    assert_empty @published_later.errors.messages
  end

  test 'should be valid if expired_at is set but not published_at' do
    @published_later.update_attribute(:published_later, false)
    assert @published_later.valid?
    assert_empty @published_later.errors.keys
    assert_empty @published_later.errors.messages
  end

  # Past from Date.current
  test 'should not be valid if published_at is BEFORE now (on create)' do
    publication = PublicationDate.new(published_later: true, published_at: 1.week.ago.to_s(:db))
    assert_not publication.valid?
    assert_equal [:published_at], publication.errors.keys
  end

  test 'should not be valid if expired_at is BEFORE now (on create)' do
    publication = PublicationDate.new(expired_prematurely: true, expired_at: 1.week.ago.to_s(:db))
    assert_not publication.valid?
    assert_equal [:expired_at], publication.errors.keys
  end

  test 'should not be valid if published_at is BEFORE now' do
    @published_later.update_attributes(published_at:  1.week.ago.to_s(:db))
    assert_not @published_later.valid?
    assert_equal [:published_at], @published_later.errors.keys
  end

  test 'should not be valid if expired_at is BEFORE now' do
    @published_later.update_attributes(expired_at: 1.week.ago.to_s(:db))
    assert_not @published_later.valid?
    assert_equal [:published_at, :expired_at], @published_later.errors.keys
  end

  # Before / After
  test 'should be valid if expired_at is set AFTER published_at' do
    @published_later.update_attribute(:expired_at, '2031-03-11 09:00:00')
    assert @published_later.valid?
    assert_empty @published_later.errors.keys
    assert_empty @published_later.errors.messages
  end

  test 'should not be valid if expired_at is set BEFORE published_at' do
    @published_later.update_attribute(:expired_at, '2025-03-11 09:00:00')
    assert_not @published_later.valid?
    assert_equal [:published_at, :expired_at], @published_later.errors.keys

    expected = { published_at: [I18n.t('published_at', scope: @i18n_scope)], expired_at: [I18n.t('expired_at', scope: @i18n_scope)] }
    assert_equal expected, @published_later.errors.messages
  end

  private

  def initialize_test
    @published_later = publication_dates(:one)
    @i18n_scope = 'form.errors.publication_date'
  end
end
