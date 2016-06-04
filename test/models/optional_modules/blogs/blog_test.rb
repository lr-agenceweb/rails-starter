# frozen_string_literal: true
require 'test_helper'

#
# == Blog model test
#
class BlogTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup :initialize_test

  #
  # == Validation rules
  #
  test 'should not be valid if no category specified' do
    blog = Blog.new
    refute blog.valid?, 'should not be valid if all fields are blank'
    assert_equal [:"translations.title", :blog_category], blog.errors.keys
  end

  test 'should not be valid if category doesn\'t exist' do
    attrs = { blog_category_id: 999 }
    blog = Blog.new attrs
    refute blog.valid?, 'should not be valid if category doesn\'t exist'
    assert_equal [:"translations.title", :blog_category], blog.errors.keys
  end

  test 'should not be valid if title is not filled' do
    attrs = { blog_category_id: @blog_category.id }
    blog = Blog.new attrs
    refute blog.valid?, 'should not be valid if title is not set'
    assert_equal [:"translations.title"], blog.errors.keys
  end

  test 'should be valid if category exists' do
    blog = set_blog_record

    assert blog.valid?, 'should be valid if category exists'
    assert_empty blog.errors.keys
  end

  test 'should not save nested audio if input file is empty' do
    attrs = { id: SecureRandom.uuid, blog_category_id: @blog_category.id, audio_attributes: { online: true } }
    blog = Blog.new attrs
    blog.set_translations(
      fr: { title: 'Bar and Foo' },
      en: { title: 'Foo and Bar' }
    )
    assert blog.audio.blank?
  end

  #
  # == Slug
  #
  test 'should be valid if title is set properly' do
    blog = Blog.new(id: SecureRandom.uuid, blog_category_id: @blog_category.id)
    blog.set_translations(
      fr: { title: 'Mon article de blog' },
      en: { title: 'My blog article' }
    )

    assert blog.valid?, 'should be valid if title is set properly'
    assert_empty blog.errors.keys

    I18n.with_locale('fr') do
      assert_equal 'Mon article de blog', blog.title
      assert_equal 'mon-article-de-blog', blog.slug
    end
    I18n.with_locale('en') do
      assert_equal 'My blog article', blog.title
      assert_equal 'my-blog-article', blog.slug
    end
  end

  test 'should add id to slug if slug already exists' do
    blog = Blog.new(id: SecureRandom.uuid, blog_category_id: @blog_category.id)
    blog.set_translations(
      fr: { title: 'Article de blog en ligne' },
      en: { title: 'Blog article online' }
    )

    assert blog.valid?, 'should be valid'
    assert_empty blog.errors.keys
    assert_empty blog.errors.messages

    I18n.with_locale('fr') do
      assert_equal 'article-de-blog-en-ligne-2', blog.slug
    end
    I18n.with_locale('en') do
      assert_equal 'blog-article-online-2', blog.slug
    end
  end

  #
  # == Counter cache
  #
  test 'should increase counter cache when creating object' do
    reset_counter_cache
    blog = set_blog_record

    blog.save
    @blog_category.reload

    assert_equal 3, @blog_category.blogs.size
  end

  test 'should decrease counter cache when destroying object' do
    reset_counter_cache
    blog = set_blog_record
    blog_2 = set_blog_record

    blog.save
    blog_2.save
    @blog_category.reload
    assert_equal 4, @blog_category.blogs.size

    blog.destroy
    @blog_category.reload
    assert_equal 3, @blog_category.blogs.size
  end

  test 'should decrease counter cache when object is set to offline' do
    reset_counter_cache
    @blog.update_attribute(:online, false)
    @blog_category.reload
    assert_equal 1, @blog_category.blogs.size
  end

  test 'should increase counter cache when object is set to online' do
    reset_counter_cache
    @blog_offline.update_attribute(:online, true)
    @blog_category.reload
    assert_equal 3, @blog_category.blogs.size
  end

  #
  # == Count
  #
  test 'should return correct count for blogs posts' do
    assert_equal 3, Blog.count
  end

  test 'should fetch only online blog posts' do
    assert_equal 2, Blog.online.count
  end

  #
  # == Prev / Next
  #
  test 'should have a next record' do
    assert @blog.next?, 'should have a next record'
  end

  test 'should have a prev record' do
    assert @blog_third.prev?, 'should have a prev record'
  end

  test 'should not have a prev record' do
    assert_not @blog.prev?, 'should not have a prev record'
  end

  test 'should not have a next record' do
    assert_not @blog_third.next?, 'should not have a next record'
  end

  #
  # == Flash content
  #
  test 'should not have flash content if no video are uploaded' do
    @blog.save!
    assert @blog.valid?, 'should be valid'
    assert_empty @blog.errors.keys
    assert @blog.video_upload_flash_notice.blank?
  end

  test 'should return correct flash content after updating a video' do
    video = fixture_file_upload 'videos/test.mp4', 'video/mp4'
    @blog.update_attributes(video_uploads_attributes: [{ video_file: video }, { video_file: video }])
    @blog.save!
    assert @blog.valid?, 'should be valid'
    assert_empty @blog.errors.keys
    assert_equal I18n.t('video_upload.flash.upload_in_progress'), @blog.video_upload_flash_notice
  end

  test 'should not have flash content if no audio is uploaded' do
    @blog.save!
    assert @blog.valid?, 'should be valid'
    assert_empty @blog.errors.keys
    assert @blog.audio_flash_notice.blank?
  end

  test 'should not have flash content after destroying audio' do
    @blog.audio.destroy
    @blog.reload
    assert @blog.audio.blank?
    assert @blog.audio_flash_notice.blank?
  end

  test 'should return correct flash content after updating an audio file' do
    audio = fixture_file_upload 'audios/test.mp3', 'audio/mpeg'
    @blog.update_attributes(audio_attributes: { audio: audio })
    assert @blog.valid?, 'should be valid'
    assert_empty @blog.errors.keys
    assert_equal I18n.t('audio.flash.upload_in_progress'), @blog.audio_flash_notice
  end

  private

  def initialize_test
    @blog = blogs(:blog_online)
    @blog_offline = blogs(:blog_offline)
    @blog_third = blogs(:blog_third)

    @blog_category = blog_categories(:one)
    @blog_category_2 = blog_categories(:two)
  end

  def reset_counter_cache
    BlogCategory.reset_column_information
    BlogCategory.all.each do |p|
      BlogCategory.update_counters p.id, blogs_count: p.blogs.length
    end

    @blog_category.reload
    @blog_category_2.reload
    assert_equal 2, @blog_category.blogs.size
    assert_equal 1, @blog_category_2.blogs.size
  end

  def set_blog_record
    attrs = { id: SecureRandom.uuid, blog_category_id: @blog_category.id, title: 'Foo and Bar' }
    blog = Blog.new attrs
    blog.set_translations(
      fr: { title: 'Bar and Foo' },
      en: { title: 'Foo and Bar' }
    )
    blog
  end
end
