# frozen_string_literal: true
require 'test_helper'

#
# BlogSetting Model test
# ========================
class BlogSettingTest < ActiveSupport::TestCase
  #
  # Validation rules
  # ==================
  test 'should not create more than one setting' do
    blog_setting = BlogSetting.new
    assert_not blog_setting.valid?
    assert_equal [:max_row], blog_setting.errors.keys
    assert_equal [I18n.t('errors.messages.max_row')], blog_setting.errors[:max_row]
  end
end
