require 'test_helper'

#
# == NewsletterSetting test
#
class NewsletterSettingTest < ActiveSupport::TestCase
  #
  # == Validation
  #
  test 'should not create more than one setting' do
    newsletter_setting = NewsletterSetting.new
    assert_not newsletter_setting.valid?
    assert_equal [:max_row], newsletter_setting.errors.keys
  end
end
