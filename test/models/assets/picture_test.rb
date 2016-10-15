# frozen_string_literal: true
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
    attachment = fixture_file_upload 'images/bart.png', 'image/png'
    Picture.create(image: attachment, attachable_type: 'Blog', attachable_id: @blog.id)
    assert @blog.pictures?, 'should have picture linked to home article'
    assert_equal 'bart.png', @blog.pictures.first.image_file_name
  end

  test 'should not have picture linked' do
    assert_not @about.pictures?, 'should not have picture linked to about article'
  end

  test 'should return first picture object' do
    attachment = fixture_file_upload 'images/bart.png', 'image/png'
    picture = Picture.create(image: attachment, attachable_type: 'Blog', attachable_id: @blog.id)
    assert_equal picture, @blog.first_pictures
  end

  test 'should return first paperclip picture object' do
    attachment = fixture_file_upload 'images/bart.png', 'image/png'
    picture = Picture.create(image: attachment, attachable_type: 'Post', attachable_id: @about_offline.id)
    assert_equal picture.image.instance, @about_offline.first_pictures_image.instance
  end

  private

  def initialize_test
    @picture = pictures(:home_three)
    @blog = blogs(:blog_online)
    @about = posts(:about)
    @about_offline = posts(:about_offline)
  end
end
