require 'test_helper'

#
# == Picture model test
#
class PictureTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  #
  # == Picture attachment
  #
  test 'should not upload image if mime type is not allowed' do
    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_nil @picture.image.path(size)
    end

    attachment = fixture_file_upload 'images/fake.txt', 'text/plain'
    @picture.update_attributes(image: attachment)

    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_not_processed 'fake.txt', size, @picture.image
    end
  end

  test 'should upload image if mime type is allowed' do
    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_nil @picture.image.path(size)
    end

    attachment = fixture_file_upload 'images/bart.png', 'image/png'
    @picture.update_attributes!(image: attachment)

    [:original, :large, :medium, :small, :thumb].each do |size|
      assert_processed 'bart.png', size, @picture.image
    end
  end

  private

  def initialize_test
    @picture = pictures(:one)
  end
end
