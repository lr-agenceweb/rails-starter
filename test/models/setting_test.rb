require 'test_helper'

#
# == Setting model test
#
class SettingTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  test 'should return title and subtitle if subtitle is not blank' do
    assert_equal @setting.title_and_subtitle, 'Rails Starter, Démarre rapidement'
  end

  test 'should return only title if subtitle is blank' do
    assert_equal @setting_without_subtitle.title_and_subtitle, 'Rails Starter'
  end

  #
  # == Logo
  #
  test 'should not upload logo if mime type is not allowed' do
    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_nil @setting.logo.path(size)
    end

    attachment = fixture_file_upload 'images/fake.txt', 'text/plain'
    @setting.update_attributes(logo: attachment)

    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_not_processed 'fake.txt', size, @setting.logo
    end
  end

  test 'should upload logo if mime type is allowed' do
    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_nil @setting.logo.path(size)
    end

    attachment = fixture_file_upload 'images/bart.png', 'image/png'
    @setting.update_attributes!(logo: attachment)

    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_processed 'bart.png', size, @setting.logo
    end
  end

  private

  def initialize_test
    @setting = settings(:one)
    @setting_without_subtitle = settings(:two)
  end
end
