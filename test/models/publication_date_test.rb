# frozen_string_literal: true
require 'test_helper'

#
# PublicationDate Model test
# ============================
class PublicationDateTest < ActiveSupport::TestCase
  setup :initialize_test

  #
  # Shoulda
  # =========
  should belong_to(:publishable)

  #
  # Published later / Expired prematurely
  # =======================================
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

    messages = { published_at: [I18n.t('past_publication', scope: @i18n_scope)] }
    assert_equal messages, publication.errors.messages
  end

  test 'should not be valid if expired_at is BEFORE now (on create)' do
    publication = PublicationDate.new(expired_prematurely: true, expired_at: 1.week.ago.to_s(:db))
    assert_not publication.valid?
    assert_equal [:expired_at], publication.errors.keys

    messages = { expired_at: [I18n.t('past_expiration', scope: @i18n_scope)] }
    assert_equal messages, publication.errors.messages
  end

  test 'should not be valid if published_at is BEFORE now' do
    @published_later.update_attributes(published_at:  1.week.ago.to_s(:db))
    assert_not @published_later.valid?
    assert_equal [:published_at], @published_later.errors.keys

    messages = { published_at: [I18n.t('past_publication', scope: @i18n_scope)] }
    assert_equal messages, @published_later.errors.messages
  end

  test 'should not be valid if expired_at is BEFORE now' do
    @published_later.update_attributes(expired_at: 1.week.ago.to_s(:db))
    assert_not @published_later.valid?
    assert_equal [:published_at, :expired_at], @published_later.errors.keys

    messages = {
      published_at: [I18n.t('published_at', scope: @i18n_scope)],
      expired_at: [
        I18n.t('expired_at', scope: @i18n_scope), I18n.t('past_expiration', scope: @i18n_scope)
      ]
    }
    assert_equal messages, @published_later.errors.messages
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

    messages = { published_at: [I18n.t('published_at', scope: @i18n_scope)], expired_at: [I18n.t('expired_at', scope: @i18n_scope)] }
    assert_equal messages, @published_later.errors.messages
  end

  test 'should return correct columns name for event' do
    expected = {
      start_attr: 'published_at',
      end_attr: 'expired_at'
    }
    assert_equal expected, PublicationDate.new.send(:klass_attrs)
  end

  #
  # Scope
  # =====
  test 'should return correct collection for "published" scope on collection' do
    # Before
    Timecop.freeze(Time.zone.local(2025, 07, 16, 14, 50, 0)) do
      blogs = Blog.published
      expected = ['Article de blog naked']
      not_expected = ['Article de blog en ligne', 'Article de blog hors ligne']

      expected_in_collection(expected, blogs)
      not_expected_in_collection(not_expected, blogs)
    end

    # Between
    Timecop.freeze(Time.zone.local(2028, 07, 16, 14, 50, 0)) do
      blogs = Blog.published
      expected = ['Article de blog naked', 'Article de blog en ligne']
      not_expected = ['Article de blog hors ligne']

      expected_in_collection(expected, blogs)
      not_expected_in_collection(not_expected, blogs)
    end

    # After
    Timecop.freeze(Time.zone.local(2032, 07, 16, 14, 50, 0)) do
      blogs = Blog.published
      expected = ['Article de blog naked']
      not_expected = ['Article de blog en ligne', 'Article de blog hors ligne']

      expected_in_collection(expected, blogs)
      not_expected_in_collection(not_expected, blogs)
    end

    @blog_offline.update_attribute(:online, true)

    # Between (and online)
    Timecop.freeze(Time.zone.local(2028, 07, 16, 14, 50, 0)) do
      blogs = Blog.published
      expected = ['Article de blog naked', 'Article de blog en ligne', 'Article de blog hors ligne']
      not_expected = []

      expected_in_collection(expected, blogs)
      not_expected_in_collection(not_expected, blogs)
    end

    # After (and online)
    Timecop.freeze(Time.zone.local(2032, 07, 16, 14, 50, 0)) do
      blogs = Blog.published
      expected = ['Article de blog naked', 'Article de blog hors ligne']
      not_expected = ['Article de blog en ligne']

      expected_in_collection(expected, blogs)
      not_expected_in_collection(not_expected, blogs)
    end
  end

  private

  def initialize_test
    @i18n_scope = 'activerecord.errors.models.publication_date.attributes'
    @published_later = publication_dates(:one)

    @blog_offline = blogs(:blog_offline)
  end

  def expected_in_collection(expected, collection_items)
    expected.each do |item|
      assert collection_items.map(&:title).include?(item), "\"#{item}\" should be included in collection"
    end
  end

  def not_expected_in_collection(not_expected, collection_items)
    not_expected.each do |item|
      assert_not collection_items.map(&:title).include?(item), "\"#{item}\" should not be included in collection"
    end
  end
end
