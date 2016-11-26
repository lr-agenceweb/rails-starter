# frozen_string_literal: true
require 'test_helper'

#
# MailingSetting Model test
# ===========================
class MailingSettingTest < ActiveSupport::TestCase
  setup :initialize_test

  #
  # Shoulda
  # =========
  should_not validate_presence_of(:email)
  should_not validate_uniqueness_of(:email)
  should allow_value('lorem@ipsum.com').for(:email)
  should_not allow_value('loremipsum.com').for(:email)

  #
  # Validation rules
  # ==================
  test 'should save mailing setting if email is nil' do
    @mailing_setting.destroy
    mailing_setting = MailingSetting.new
    assert mailing_setting.valid?
    assert mailing_setting.errors.keys.empty?
  end

  test 'should save mailing setting if email is blank' do
    @mailing_setting.destroy
    mailing_setting = MailingSetting.new(email: '')
    assert mailing_setting.valid?
    assert mailing_setting.errors.keys.empty?
  end

  test 'should save mailing setting if email is correct' do
    @mailing_setting.destroy
    mailing_setting = MailingSetting.new(email: 'mailing@test.com')
    assert mailing_setting.valid?
    assert mailing_setting.errors.keys.empty?
  end

  test 'should not save mailing setting if email is not correct' do
    @mailing_setting.destroy
    mailing_setting = MailingSetting.new(email: 'mailing')
    assert_not mailing_setting.valid?
    assert_equal [:email], mailing_setting.errors.keys
  end

  #
  # == Validation
  #
  test 'should not create more than one setting' do
    mailing_setting = MailingSetting.new
    assert_not mailing_setting.valid?
    assert_equal [:max_row], mailing_setting.errors.keys
    assert_equal [I18n.t('errors.messages.max_row')], mailing_setting.errors[:max_row]
  end

  private

  def initialize_test
    @mailing_setting = mailing_settings(:one)
  end
end
