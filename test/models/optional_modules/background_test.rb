# frozen_string_literal: true
require 'test_helper'

#
# Background Model test
# =========================
class BackgroundTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  # Constants
  SIZE_PLUS_1 = Background::ATTACHMENT_MAX_SIZE + 1

  #
  # Shoulda
  # =========
  should belong_to(:attachable)
  should validate_presence_of(:attachable_type)

  should validate_inclusion_of(:attachable_type)
    .in_array(%w(Page))

  should have_attached_file(:image)
  should_not validate_attachment_presence(:image)
  should validate_attachment_content_type(:image)
    .allowing('image/jpg', 'image/png')
    .rejecting('text/plain', 'text/xml')
  should validate_attachment_size(:image)
    .less_than((SIZE_PLUS_1 - 1).megabytes)

  #
  # Background
  # ==============
  test 'should have correct child_classes' do
    child_classes = Background.child_classes
    assert_includes child_classes, :Home
    assert_includes child_classes, :About
    assert_includes child_classes, :Contact
    assert_includes child_classes, :LegalNotice
    assert_not child_classes.include?(:Blog)
  end

  test 'should not upload background if mime type is not allowed' do
    [:original, :background, :large, :medium, :small].each do |size|
      assert_nil @background.image.path(size)
    end

    attachment = fixture_file_upload 'images/fake.txt', 'text/plain'
    @background.update_attributes(image: attachment)

    [:original, :background, :large, :medium, :small].each do |size|
      assert_not_processed 'fake.txt', size, @background.image
    end
  end

  test 'should upload background if mime type is allowed' do
    [:original, :background, :large, :medium, :small].each do |size|
      assert_nil @background.image.path(size)
    end

    attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
    @background.update_attributes!(image: attachment)

    [:original, :background, :large, :medium, :small].each do |size|
      assert_processed 'background-paris.jpg', size, @background.image
    end
  end

  test 'should return pages except when backgroud setted' do
    page_dropdown_items = Page.except_already_background
    expected = %w(Search GuestBook Event Test)
    not_expected = %w(Home Contact Blog)

    expected_in_pages_dropdown(expected, page_dropdown_items)
    not_expected_in_pages_dropdown(not_expected, page_dropdown_items)
  end

  test 'should return menu_title for pages without background' do
    page_dropdown_items = Page.handle_pages_for_background(@background_home)
    assert_includes page_dropdown_items, ['Accueil', pages(:home).id]
    assert_includes page_dropdown_items, ['A propos', pages(:about).id]
    assert_includes page_dropdown_items, ['Recherche', pages(:search).id]
    assert_includes page_dropdown_items, ['Livre d\'or', pages(:guest_book).id]
    assert_includes page_dropdown_items, ['Evénements', pages(:event).id]
    assert_not page_dropdown_items.include?(['Contact', pages(:contact).id])
    assert_not page_dropdown_items.include?(['Blog', pages(:blog).id])
  end

  private

  def initialize_test
    @background = backgrounds(:contact)
    @background_home = backgrounds(:home)
  end

  def expected_in_pages_dropdown(expected, page_dropdown_items)
    expected.each do |item|
      assert page_dropdown_items.map(&:name).include?(item), "\"#{item}\" should be included in dropdown"
    end
  end

  def not_expected_in_pages_dropdown(not_expected, page_dropdown_items)
    not_expected.each do |item|
      assert_not page_dropdown_items.map(&:name).include?(item), "\"#{item}\" should not be included in dropdown"
    end
  end
end
