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

    assert_not_processed 'fake.txt', :original, @background.image
    assert_not_processed 'fake.txt', :background, @background.image
    assert_not_processed 'fake.txt', :large, @background.image
    assert_not_processed 'fake.txt', :medium, @background.image
    assert_not_processed 'fake.txt', :small, @background.image
  end

  test 'should upload background if mime type is allowed' do
    assert_nil @background.image.path(:original)
    assert_nil @background.image.path(:background)
    assert_nil @background.image.path(:large)
    assert_nil @background.image.path(:medium)
    assert_nil @background.image.path(:small)

    attachment = fixture_file_upload 'images/background-paris.jpg', 'image/jpeg'
    @background.update_attributes!(image: attachment)

    assert_processed 'background-paris.jpg', :original, @background.image
    assert_processed 'background-paris.jpg', :background, @background.image
    assert_processed 'background-paris.jpg', :large, @background.image
    assert_processed 'background-paris.jpg', :medium, @background.image
    assert_processed 'background-paris.jpg', :small, @background.image
  end

  private

  def initialize_test
    @background = backgrounds(:contact)
  end
end
