# frozen_string_literal: true
require 'test_helper'

#
# NewsletterUser Model test
# ===========================
class NewsletterUserTest < ActiveSupport::TestCase
  setup :initialize_test

  #
  # Shoulda
  # =========
  should belong_to(:newsletter_user_role)

  should validate_presence_of(:email)
  should validate_presence_of(:lang)
  should validate_presence_of(:newsletter_user_role_id)

  should validate_inclusion_of(:lang)
    .in_array(I18n.available_locales.map(&:to_s))
  should validate_inclusion_of(:newsletter_user_role_id)
    .in_array(NewsletterUserRole.all.map(&:id))

  should validate_uniqueness_of(:email)
  should validate_absence_of(:nickname)

  #
  # Validation rules
  # ==================
  test 'should not save if email is nil' do
    newsletter_user = NewsletterUser.new newsletter_user_role: @newsletter_user_role_tester
    assert_not newsletter_user.valid?
    assert_equal [:email], newsletter_user.errors.keys
  end

  test 'should not save if email is blank' do
    newsletter_user = NewsletterUser.new(email: '', newsletter_user_role: @newsletter_user_role_tester)
    assert_not newsletter_user.valid?
    assert_equal [:email], newsletter_user.errors.keys
  end

  test 'should not save if email is not correct' do
    newsletter_user = NewsletterUser.new(email: 'newsletter', newsletter_user_role: @newsletter_user_role_tester)
    assert_not newsletter_user.valid?
    assert_equal [:email], newsletter_user.errors.keys
  end

  test 'should not save if email is correct but lang is forbidden' do
    newsletter_user = NewsletterUser.new(email: 'newsletter@test.com', lang: 'de', newsletter_user_role: @newsletter_user_role_tester)
    assert_not newsletter_user.valid?
    assert_equal [:lang], newsletter_user.errors.keys
  end

  test 'should not save if email is already taken' do
    newsletter_user = NewsletterUser.new(email: 'newsletteruser@test.fr', lang: 'fr', newsletter_user_role: @newsletter_user_role_tester)
    assert_not newsletter_user.valid?
    assert_equal [:email], newsletter_user.errors.keys
  end

  test 'should save if all good' do
    newsletter_user = NewsletterUser.new(email: 'newsletter@test.com', lang: 'fr', newsletter_user_role: @newsletter_user_role_tester)
    assert newsletter_user.valid?
    assert newsletter_user.errors.keys.empty?
  end

  test 'should not save if captcha is filled' do
    newsletter_user = NewsletterUser.new(email: 'newsletteruseruniq@test.fr', lang: 'fr', nickname: 'robot', newsletter_user_role: @newsletter_user_role_tester)
    assert_not newsletter_user.valid?
    assert_equal [:nickname], newsletter_user.errors.keys
  end

  test 'should not save if role is not allowed' do
    newsletter_user = NewsletterUser.new(email: 'newsletteruseruniq@test.fr', lang: 'fr', nickname: '', newsletter_user_role_id: 9999)
    assert_not newsletter_user.valid?
    assert_equal [:newsletter_user_role_id], newsletter_user.errors.keys
  end

  test 'should prevent changing email on update' do
    @newsletter_user.update_attribute(:email, 'lorem@ipsum.com')
    assert_equal 'foo@bar.com', @newsletter_user.email
  end

  #
  # Misc
  # ========
  test 'should have testers' do
    assert NewsletterUser.testers.map(&:email).include?('foo@bar.com'), '"foo@bar.com" should be tester'
    assert_not NewsletterUser.testers.map(&:email).include?('newsletteruser@test.fr'), '"newsletteruser@test.fr" should not be tester'
  end

  test 'should have subscriber' do
    assert NewsletterUser.subscribers.map(&:email).include?('newsletteruser@test.fr'), '"newsletteruser@test.fr" should be subscriber'
    assert_not NewsletterUser.subscribers.map(&:email).include?('foo@bar.com'), '"foo@bar.com" should not be subscriber'
  end

  test 'should extract name from email' do
    assert_equal 'foo', @newsletter_user.extract_name_from_email
  end

  private

  def initialize_test
    @email = 'foo@bar.cc'
    @lang = 'fr'
    @newsletter_user = newsletter_users(:newsletter_user_test)
    @newsletter_user_role_tester = newsletter_user_roles(:tester)
    @newsletter_user_role_subscriber = newsletter_user_roles(:subscriber)
  end
end
