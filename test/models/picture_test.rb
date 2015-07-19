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
    assert_nil @picture.image.path(:original)
    assert_nil @picture.image.path(:large)
    assert_nil @picture.image.path(:medium)
    assert_nil @picture.image.path(:small)
    assert_nil @picture.image.path(:thumb)

    attachment = fixture_file_upload 'images/fake.txt', 'text/plain'
    @picture.update_attributes(image: attachment)

    assert_not_processed 'fake.txt', :original, @picture.image
    assert_not_processed 'fake.txt', :large, @picture.image
    assert_not_processed 'fake.txt', :medium, @picture.image
    assert_not_processed 'fake.txt', :small, @picture.image
    assert_not_processed 'fake.txt', :thumb, @picture.image
  end

  test 'should upload image if mime type is allowed' do
    assert_nil @picture.image.path(:original)
    assert_nil @picture.image.path(:large)
    assert_nil @picture.image.path(:medium)
    assert_nil @picture.image.path(:small)
    assert_nil @picture.image.path(:thumb)

    attachment = fixture_file_upload 'images/bart.png', 'image/png'
    @picture.update_attributes!(image: attachment)

    assert_processed 'bart.png', :original, @picture.image
    assert_processed 'bart.png', :large, @picture.image
    assert_processed 'bart.png', :medium, @picture.image
    assert_processed 'bart.png', :small, @picture.image
    assert_processed 'bart.png', :thumb, @picture.image
  end

  private

  def initialize_test
    @picture = pictures(:one)
  end
end
