# frozen_string_literal: true
require 'test_helper'

#
# == Background Model test
#
class BackgroundTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  #
  # == Background
  #
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

  test 'should return categories except when backgroud setted' do
    category_dropdown_items = Category.except_already_background
    expected = %w(Search GuestBook Event Test)
    not_expected = %w(Home Contact Blog)

    expected_in_category_dropdown(expected, category_dropdown_items)
    not_expected_in_category_dropdown(not_expected, category_dropdown_items)
  end

  test 'should return menu_title for pages without background' do
    category_dropdown_items = Category.handle_pages_for_background(@background_home)
    assert_includes category_dropdown_items, ['Accueil', categories(:home).id]
    assert_includes category_dropdown_items, ['A propos', categories(:about).id]
    assert_includes category_dropdown_items, ['Recherche', categories(:search).id]
    assert_includes category_dropdown_items, ['Livre d\'or', categories(:guest_book).id]
    assert_includes category_dropdown_items, ['Evénements', categories(:event).id]
    assert_not category_dropdown_items.include?(['Contact', categories(:contact).id])
    assert_not category_dropdown_items.include?(['Blog', categories(:blog).id])
  end

  private

  def initialize_test
    @background = backgrounds(:contact)
    @background_home = backgrounds(:home)
  end

  def expected_in_category_dropdown(expected, category_dropdown_items)
    expected.each do |item|
      assert category_dropdown_items.map(&:name).include?(item), "\"#{item}\" should be included in dropdown"
    end
  end

  def not_expected_in_category_dropdown(not_expected, category_dropdown_items)
    not_expected.each do |item|
      assert_not category_dropdown_items.map(&:name).include?(item), "\"#{item}\" should not be included in dropdown"
    end
  end
end
