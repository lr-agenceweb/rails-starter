# frozen_string_literal: true
require 'test_helper'

#
# == BlogSetting test
#
class BlogSettingTest < ActiveSupport::TestCase
  #
  # == Validation
  #
  test 'should not create more than one setting' do
    blog_setting = BlogSetting.new
    assert_not blog_setting.valid?
    assert_equal [:max_row], blog_setting.errors.keys
    assert_equal [I18n.t('form.errors.max_row')], blog_setting.errors[:max_row]
  end
end
