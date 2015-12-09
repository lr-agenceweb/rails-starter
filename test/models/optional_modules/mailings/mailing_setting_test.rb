require 'test_helper'

#
# == MailingSettingTest Model
#
class MailingSettingTest < ActiveSupport::TestCase
  test 'should save mailing setting if email is nil' do
    mailing_user = MailingSetting.new
    assert mailing_user.valid?
    assert mailing_user.errors.keys.empty?
  end

  test 'should save mailing setting if email is blank' do
    mailing_user = MailingSetting.new(email: '')
    assert mailing_user.valid?
    assert mailing_user.errors.keys.empty?
  end

  test 'should save mailing setting if email is correct' do
    mailing_user = MailingSetting.new(email: 'mailing@test.com')
    assert mailing_user.valid?
    assert mailing_user.errors.keys.empty?
  end

  test 'should not save mailing setting if email is not correct' do
    mailing_user = MailingSetting.new(email: 'mailing')
    assert_not mailing_user.valid?
    assert_equal [:email], mailing_user.errors.keys
  end
end