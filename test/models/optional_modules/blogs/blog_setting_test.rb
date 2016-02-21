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
  end
end
