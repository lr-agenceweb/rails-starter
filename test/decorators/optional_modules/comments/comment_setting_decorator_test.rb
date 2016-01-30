require 'test_helper'

#
# == CommentSettingDecorator test
#
class CommentSettingDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  private

  def initialize_test
    @comment_setting = comment_settings(:one)
  end
end
