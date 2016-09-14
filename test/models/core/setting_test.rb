# frozen_string_literal: true
require 'test_helper'

#
# == Setting model test
#
class SettingTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  #
  # == Validation rules
  #
  test 'should not create more than one setting' do
    @setting_without_subtitle.destroy

    setting = Setting.new default_attrs
    assert_not setting.valid?
    assert_equal [:max_row], setting.errors.keys
    assert_equal [I18n.t('form.errors.max_row')], setting.errors[:max_row]
  end

  test 'should not update if name is empty' do
    @setting.update_attributes(name: '')
    assert_not @setting.valid?
    assert_equal [:name], @setting.errors.keys
  end

  test 'should not update if email is empty' do
    @setting.update_attributes(email: '')
    assert_not @setting.valid?
    assert_equal [:email], @setting.errors.keys
  end

  test 'should not update if email is not valid' do
    @setting.update_attributes(email: 'fakeemail')
    assert_not @setting.valid?
    assert_equal [:email], @setting.errors.keys
  end

  test 'should not be valid if enum value is not correct for date_format' do
    @setting.update_attributes(date_format: :fake)
    assert_not @setting.valid?
    assert_equal [:date_format], @setting.errors.keys
  end

  # == Per page
  test 'should not update if per_page params is not alloweded' do
    @setting.update_attributes(per_page: 31)
    assert_not @setting.valid?, 'should not update if per_page param is not allowed'
    assert_equal [:per_page], @setting.errors.keys
  end

  test 'should not update if per_page params is empty' do
    @setting.update_attributes(per_page: nil)
    assert_not @setting.valid?, 'should not update if per_page params is empty'
    assert_equal [:per_page], @setting.errors.keys
  end

  test 'should update if per_page params is allowed' do
    @setting.update_attributes(per_page: 5)
    assert @setting.valid?, 'should update if per_page params is allowed'
    assert @setting.errors.keys.empty?
  end

  #
  # == Methods
  #
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

    upload_paperclip_attachment

    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_processed 'bart.png', size, @setting.logo
    end

    assert_equal 'bart.png', @setting.logo_file_name
    assert_equal 'image/png', @setting.logo_content_type
    assert @setting.logo?, 'a logo should have been uploaded'
  end

  test 'should be able to destroy logo' do
    existing_styles = []
    upload_paperclip_attachment

    # Save logo styles in array
    @setting.logo.styles.keys.collect do |size|
      f = @setting.logo.path(size)
      assert File.exist?(f), "File #{f} should exist"
      existing_styles << f
    end

    # Destroy logo
    @setting.logo.destroy

    assert_nil @setting.logo_file_name
    assert_not @setting.logo?

    existing_styles.each do |file|
      assert_not File.exist?(file), "#{file} should not exist anymore"
    end
  end

  #
  # == Logo footer
  #
  test 'should not upload logo_footer if mime type is not allowed' do
    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_nil @setting.logo_footer.path(size)
    end

    attachment = fixture_file_upload 'images/fake.txt', 'text/plain'
    @setting.update_attributes(logo_footer: attachment)

    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_not_processed 'fake.txt', size, @setting.logo_footer
    end
  end

  test 'should upload logo_footer if mime type is allowed' do
    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_nil @setting.logo_footer.path(size)
    end

    upload_paperclip_attachment 'logo_footer'

    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_processed 'bart.png', size, @setting.logo_footer
    end

    assert_equal 'bart.png', @setting.logo_footer_file_name
    assert_equal 'image/png', @setting.logo_footer_content_type
    assert @setting.logo_footer?, 'a logo_footer should have been uploaded'
  end

  test 'should be able to destroy logo_footer' do
    existing_styles = []
    upload_paperclip_attachment 'logo_footer'

    # Save logo_footer styles in array
    @setting.logo_footer.styles.keys.collect do |size|
      f = @setting.logo_footer.path(size)
      assert File.exist?(f), "File #{f} should exist"
      existing_styles << f
    end

    # Destroy logo_footer
    @setting.logo_footer.destroy

    assert_nil @setting.logo_footer_file_name
    assert_not @setting.logo_footer?

    existing_styles.each do |file|
      assert_not File.exist?(file), "#{file} should not exist anymore"
    end
  end

  private

  def initialize_test
    @setting = settings(:one)
    @setting_without_subtitle = settings(:two)
  end

  def upload_paperclip_attachment(property = 'logo')
    attachment = fixture_file_upload 'images/bart.png', 'image/png'
    @setting.update_attributes!("#{property}": attachment)
  end

  def default_attrs
    {
      name: 'My name',
      title: 'My title',
      email: 'my-email@test.com'
    }
  end
end
