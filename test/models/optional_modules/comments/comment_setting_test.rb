# frozen_string_literal: true
require 'test_helper'

#
# CommentSetting Model test
# ===========================
class CommentSettingTest < ActiveSupport::TestCase
  #
  # Validation rules
  # ==================
  test 'should not create more than one setting' do
    comment_setting = CommentSetting.new
    assert_not comment_setting.valid?
    assert_equal [:max_row], comment_setting.errors.keys
    assert_equal [I18n.t('errors.messages.max_row')], comment_setting.errors[:max_row]
  end
end
