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

  private

  def initialize_test
    @background = backgrounds(:contact)
  end
end
