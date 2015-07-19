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
  test 'should not upload background if mime type is not allowed' do
    assert_nil @background.image.path(:original)
    assert_nil @background.image.path(:background)
    assert_nil @background.image.path(:large)
    assert_nil @background.image.path(:medium)
    assert_nil @background.image.path(:small)

    attachment = fixture_file_upload 'images/fake.txt', 'text/plain'
    @background.update_attributes(image: attachment)

    assert_not_processed 'fake.txt', :original
    assert_not_processed 'fake.txt', :background
    assert_not_processed 'fake.txt', :large
    assert_not_processed 'fake.txt', :medium
    assert_not_processed 'fake.txt', :small
  end

  test 'should upload background if mime type is allowed' do
    assert_nil @background.image.path(:original)
    assert_nil @background.image.path(:background)
    assert_nil @background.image.path(:large)
    assert_nil @background.image.path(:medium)
    assert_nil @background.image.path(:small)

    attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
    @background.update_attributes!(image: attachment)

    assert_processed 'background-paris.jpg', :original
    assert_processed 'background-paris.jpg', :background
    assert_processed 'background-paris.jpg', :large
    assert_processed 'background-paris.jpg', :medium
    assert_processed 'background-paris.jpg', :small
  end

  private

  def initialize_test
    @background = backgrounds(:contact)
  end

  def assert_processed(filename, style)
    path = @background.image.path(style)
    assert_match Regexp.new(Regexp.escape(filename) + '$'), path
    assert File.exist?(path), "#{style} not processed"
  end

  def assert_not_processed(filename, style)
    path = @background.image.path(style)
    assert_match Regexp.new(Regexp.escape(filename) + '$'), path
    assert_not File.exist?(@background.image.path(style)), "#{style} unduly processed"
  end
end
