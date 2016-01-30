require 'test_helper'

#
# == CommentSetting model test
#
class CommentSettingTest < ActiveSupport::TestCase
  setup :initialize_test

  private

  def initialize_test
    @comment_setting = comment_settings(:one)
  end
end
