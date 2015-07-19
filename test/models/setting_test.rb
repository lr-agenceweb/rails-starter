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
    assert_nil @setting.logo.path(:original)
    assert_nil @setting.logo.path(:large)
    assert_nil @setting.logo.path(:medium)
    assert_nil @setting.logo.path(:small)
    assert_nil @setting.logo.path(:thumb)

    attachment = fixture_file_upload 'images/fake.txt', 'text/plain'
    @setting.update_attributes(logo: attachment)

    assert_not_processed 'fake.txt', :original, @setting.logo
    assert_not_processed 'fake.txt', :large, @setting.logo
    assert_not_processed 'fake.txt', :medium, @setting.logo
    assert_not_processed 'fake.txt', :small, @setting.logo
    assert_not_processed 'fake.txt', :thumb, @setting.logo
  end

  test 'should upload logo if mime type is allowed' do
    assert_nil @setting.logo.path(:original)
    assert_nil @setting.logo.path(:large)
    assert_nil @setting.logo.path(:medium)
    assert_nil @setting.logo.path(:small)
    assert_nil @setting.logo.path(:thumb)

    attachment = fixture_file_upload 'images/bart.png', 'image/png'
    @setting.update_attributes!(logo: attachment)

    assert_processed 'bart.png', :original, @setting.logo
    assert_processed 'bart.png', :large, @setting.logo
    assert_processed 'bart.png', :medium, @setting.logo
    assert_processed 'bart.png', :small, @setting.logo
    assert_processed 'bart.png', :thumb, @setting.logo
  end

  private

  def initialize_test
    @setting = settings(:one)
    @setting_without_subtitle = settings(:two)
  end
end
