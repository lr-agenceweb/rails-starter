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

  test 'should have picture linked' do
    skip 'skip this test because of travis which doesn\'t understand this'
    attachment = fixture_file_upload 'images/bart.png', 'image/png'
    Picture.create(image: attachment, attachable_type: 'Post', attachable_id: @home_post.id)
    assert @home_post.pictures?, 'should have picture linked to home article'
  end

  test 'should not have picture linked' do
    assert_not @about_post.pictures?, 'should not have picture linked to about article'
  end

  test 'should return first picture object' do
    skip 'skip this test because of travis which doesn\'t understand this'
    attachment = fixture_file_upload 'images/bart.png', 'image/png'
    picture = Picture.create(image: attachment, attachable_type: 'Post', attachable_id: @home_post.id)
    assert_equal picture, @home_post.first_pictures
  end

  test 'should return first paperclip picture object' do
    attachment = fixture_file_upload 'images/bart.png', 'image/png'
    picture = Picture.create(image: attachment, attachable_type: 'Post', attachable_id: @about_2_post.id)
    assert_equal picture.image.instance, @about_2_post.first_pictures_image.instance
  end

  private

  def initialize_test
    @picture = pictures(:home)
    @home_post = posts(:home)
    @about_post = posts(:about)
    @about_2_post = posts(:about_2)
  end
end
