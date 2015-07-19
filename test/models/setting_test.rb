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
  test 'should not upload attachment if mime type is not allowed' do
    assert_nil @setting.logo.path(:large)
    assert_nil @setting.logo.path(:medium)
    assert_nil @setting.logo.path(:small)
    assert_nil @setting.logo.path(:thumb)

    attachment = fixture_file_upload 'images/fake.txt', 'text/plain'
    @setting.update_attributes(logo: attachment)

    assert_not_processed 'fake.txt', :large
    assert_not_processed 'fake.txt', :medium
    assert_not_processed 'fake.txt', :small
    assert_not_processed 'fake.txt', :thumb
  end

  test 'should upload attachment if mime type is allowed' do
    assert_nil @setting.logo.path(:large)
    assert_nil @setting.logo.path(:medium)
    assert_nil @setting.logo.path(:small)
    assert_nil @setting.logo.path(:thumb)

    attachment = fixture_file_upload 'images/bart.png', 'image/png'
    @setting.update_attributes!(logo: attachment)

    assert_processed 'bart.png', :large
    assert_processed 'bart.png', :medium
    assert_processed 'bart.png', :small
    assert_processed 'bart.png', :thumb
  end

  private

  def initialize_test
    @setting = settings(:one)
    @setting_without_subtitle = settings(:two)
  end

  def assert_processed(filename, style)
    path = @setting.logo.path(style)
    assert_match Regexp.new(Regexp.escape(filename) + '$'), path
    assert File.exist?(path), "#{style} not processed"
  end

  def assert_not_processed(filename, style)
    path = @setting.logo.path(style)
    assert_match Regexp.new(Regexp.escape(filename) + '$'), path
    assert_not File.exist?(@setting.logo.path(style)), "#{style} unduly processed"
  end
end
