# frozen_string_literal: true
require 'test_helper'

#
# == MailingUserTest Model
#
class MailingUserTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should be linked to correct emailing message(s)' do
    assert_includes @mailing_user.mailing_messages.map(&:title), @mailing_message.title
    assert_not_includes @mailing_user.mailing_messages.map(&:title), @mailing_message_two.title
  end

  #
  # == Validations
  #
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

  private

  def initialize_test
    @mailing_user = mailing_users(:one)
    @mailing_message = mailing_messages(:one)
    @mailing_message_two = mailing_messages(:two)
  end
end
