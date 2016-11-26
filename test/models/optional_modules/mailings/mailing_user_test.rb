# frozen_string_literal: true
require 'test_helper'

#
# MailingUser Model test
# ========================
class MailingUserTest < ActiveSupport::TestCase
  setup :initialize_test

  #
  # Shoulda
  # =========
  should have_many(:mailing_messages)
  should have_many(:mailing_message_users)

  should validate_presence_of(:email)
  should validate_presence_of(:lang)

  should validate_uniqueness_of(:email)
  should allow_value('lorem@ipsum.com').for(:email)
  should_not allow_value('loremipsum.com').for(:email)

  should validate_inclusion_of(:lang)
    .in_array(I18n.available_locales.map(&:to_s))

  #
  # Validation rules
  # ==================
  test 'should not save if email is nil' do
    mailing_user = MailingUser.new
    assert_not mailing_user.valid?
    assert_equal [:email, :lang], mailing_user.errors.keys
  end

  test 'should save if email is blank' do
    mailing_user = MailingUser.new(email: '')
    assert_not mailing_user.valid?
    assert_equal [:email, :lang], mailing_user.errors.keys
  end

  test 'should not save if email is not correct' do
    mailing_user = MailingUser.new(email: 'mailing')
    assert_not mailing_user.valid?
    assert_equal [:email, :lang], mailing_user.errors.keys
  end

  test 'should not save if email is correct but not lang' do
    mailing_user = MailingUser.new(email: 'mailing@test.com')
    assert_not mailing_user.valid?
    assert_equal [:lang], mailing_user.errors.keys
  end

  test 'should not save if email is correct but lang is forbidden' do
    mailing_user = MailingUser.new(email: 'mailing@test.com', lang: 'de')
    assert_not mailing_user.valid?
    assert_equal [:lang], mailing_user.errors.keys
  end

  test 'should not save if email is already taken' do
    mailing_user = MailingUser.new(email: 'lorie@mailing.com', lang: 'fr')
    assert_not mailing_user.valid?
    assert_equal [:email], mailing_user.errors.keys
  end

  test 'should save if email is correct and with lang' do
    mailing_user = MailingUser.new(email: 'mailing@test.com', lang: 'fr')
    assert mailing_user.valid?
    assert mailing_user.errors.keys.empty?
  end

  test 'should be linked to correct emailing message(s)' do
    assert_includes @mailing_user.mailing_messages.map(&:title), @mailing_message.title
    assert_not_includes @mailing_user.mailing_messages.map(&:title), @mailing_message_two.title
  end

  private

  def initialize_test
    @mailing_user = mailing_users(:one)
    @mailing_message = mailing_messages(:one)
    @mailing_message_two = mailing_messages(:two)
  end
end
