# frozen_string_literal: true
require 'test_helper'

#
# == CommentSetting model test
#
class CommentSettingTest < ActiveSupport::TestCase
  #
  # == Validation
  #
  test 'should not create more than one setting' do
    comment_setting = CommentSetting.new
    assert_not comment_setting.valid?
    assert_equal [:max_row], comment_setting.errors.keys
    assert_equal [I18n.t('form.errors.max_row')], comment_setting.errors[:max_row]
  end
end
