# frozen_string_literal: true
require 'test_helper'

#
# Setting Model test
# ====================
class SettingTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  #
  # Shoulda
  # =========
  should validate_presence_of(:name)
  should validate_presence_of(:email)
  should validate_presence_of(:per_page)
  should validate_presence_of(:date_format)

  should allow_value('lorem@ipsum.com').for(:email)
  should_not allow_value('loremipsum.com').for(:email)

  should validate_inclusion_of(:per_page)
    .in_array(Setting.per_page_values)
  should define_enum_for(:date_format)
    .with(Setting.date_formats.keys)

  # Logo
  should have_attached_file(:logo)
  should_not validate_attachment_presence(:logo)
  should validate_attachment_content_type(:logo)
    .allowing('image/jpg', 'image/png')
    .rejecting('text/plain', 'text/xml')
  should validate_attachment_size(:logo)
    .less_than(Setting::ATTACHMENT_MAX_SIZE.megabytes)

  # Logo footer
  should have_attached_file(:logo_footer)
  should_not validate_attachment_presence(:logo_footer)
  should validate_attachment_content_type(:logo_footer)
    .allowing('image/jpg', 'image/png')
    .rejecting('text/plain', 'text/xml')
  should validate_attachment_size(:logo_footer)
    .less_than(Setting::ATTACHMENT_MAX_SIZE.megabytes)

  #
  # Columns
  # =========
  test 'should return true if subtitle not blank' do
    assert @setting.send(:subtitle?)
  end

  #
  # Validation rules
  # ==================
  test 'should not create more than one setting' do
    @setting_without_subtitle.destroy

    setting = Setting.new default_attrs
    assert_not setting.valid?
    assert_equal [:max_row], setting.errors.keys
    assert_equal [I18n.t('errors.messages.max_row')], setting.errors[:max_row]
  end

  test 'should not update if name is empty' do
    @setting.update_column(:name, '')
    assert_not @setting.valid?
    assert_equal [:name], @setting.errors.keys
  end

  test 'should not update if email is empty' do
    @setting.update_column(:email, '')
    assert_not @setting.valid?
    assert_equal [:email], @setting.errors.keys
  end

  test 'should not update if email is not valid' do
    @setting.update_column(:email, 'fakeemail')
    assert_not @setting.valid?
    assert_equal [:email], @setting.errors.keys
  end

  # Date format
  test 'should be valid if enum value is correct for date_format' do
    @setting.update_column(:date_format, :ago)
    assert @setting.valid?
    assert @setting.errors.keys.empty?
  end

  test 'should not be valid if enum value is not correct for date_format' do
    @setting.update_column(:date_format, 99)
    assert_not @setting.valid?
    assert_equal [:date_format], @setting.errors.keys
  end

  test 'should return correct date_format enum translations for collection' do
    expected = [['30/04/2016 15:32', 'with_time'], ['30/04/2016', 'without_time'], ['Il y a 10 minutes', 'ago']]
    assert_equal expected, Setting.date_format_attributes_for_form
  end

  # Per page
  test 'should not update if per_page params is not alloweded' do
    @setting.update_column(:per_page, 31)
    assert_not @setting.valid?, 'should not update if per_page param is not allowed'
    assert_equal [:per_page], @setting.errors.keys
  end

  test 'should not update if per_page params is empty' do
    @setting.update_column(:per_page, nil)
    assert_not @setting.valid?, 'should not update if per_page params is empty'
    assert_equal [:per_page], @setting.errors.keys
  end

  test 'should update if per_page params is allowed' do
    @setting.update_column(:per_page, 5)
    assert @setting.valid?, 'should update if per_page params is allowed'
    assert @setting.errors.keys.empty?
  end

  #
  # Logo
  # ======
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
  # Logo footer
  # =============
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
