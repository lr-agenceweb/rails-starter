require 'test_helper'

#
# == MailingSettingDecorator test
#
class MailingSettingDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  test 'should use name in general settings if left empty' do
    assert_equal 'Rails Starter', @mailing_setting_decorated.name_status
  end

  test 'should use email in general settings if left empty' do
    assert_equal 'demo@rails-starter.com', @mailing_setting_decorated.email_status
  end

  test 'should use own name attribute if filled' do
    @mailing_setting.update_attribute(:name, 'No Reply')
    assert_equal 'No Reply', @mailing_setting_decorated.name_status
  end

  test 'should use own email attribute if filled' do
    @mailing_setting.update_attribute(:email, 'demo@mailing.com')
    assert_equal 'demo@mailing.com', @mailing_setting_decorated.email_status
  end

  private

  def initialize_test
    @mailing_setting = mailing_settings(:one)
    @mailing_setting_decorated = MailingSettingDecorator.new(@mailing_setting)
  end
end
