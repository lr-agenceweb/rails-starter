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
  end
end
