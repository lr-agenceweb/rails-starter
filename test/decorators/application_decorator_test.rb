# frozen_string_literal: true
require 'test_helper'

#
# == ApplicationDecorator test
#
class ApplicationDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # == Dynamic menu link
  #
  test 'should return correct menu link for pages' do
    assert_equal '/contact', @contact_decorated.menu_link('Contact')
    assert_equal 'http://test.host/contact', @contact_decorated.menu_link('Contact', true)
    assert_equal '/', @contact_decorated.menu_link('Home')
    assert_equal 'http://test.host/', @contact_decorated.menu_link('Home', true)
  end

  #
  # == DateTime
  #
  test 'should return correct created_at format' do
    assert_equal '01 fév. 13h32', @blog_article_decorated.created_at
  end

  test 'should return correct date of creation for comment' do
    assert_equal '<time datetime="2016-01-30T13:54:20+01:00" class="date-format" title="30/01/2016 13:54">30/01/2016 13:54</time>', @comment_decorated.pretty_created_at(@setting.date_format)
  end

  test 'should return date with time' do
    @setting.update_attribute(:date_format, 0)
    assert_equal '<time datetime="2016-01-30T13:54:20+01:00" class="date-format" title="30/01/2016 13:54">30/01/2016 13:54</time>', @comment_decorated.pretty_created_at(@setting.date_format)
  end

  test 'should return date without time' do
    @setting.update_attribute(:date_format, 1)
    assert_equal '<time datetime="2016-01-30T13:54:20+01:00" class="date-format" title="30/01/2016">30/01/2016</time>', @comment_decorated.pretty_created_at(@setting.date_format)
  end

  test 'should return date with time if format is "ago"' do
    @setting.update_attribute(:date_format, 2)
    assert_equal '<time datetime="2016-01-30T13:54:20+01:00" class="date-format" title="30/01/2016 13:54">30/01/2016 13:54</time>', @comment_decorated.pretty_created_at(@setting.date_format)
  end

  #
  # == File
  #
  test 'should return correct file name without extension' do
    assert_equal 'Foo bar 2016', @audio_decorated.file_name_without_extension
  end

  #
  # == Prev / Next
  #
  test 'should return correct prev blog' do
    assert_equal blog_category_blog_path(@blog_article.blog_category, @blog_article), @blog_article_2_decorated.prev_post
  end

  test 'should return correct next blog' do
    assert_equal blog_category_blog_path(@blog_article_2.blog_category, @blog_article_2), @blog_article_decorated.next_post
  end

  #
  # == Paginator
  #
  test 'should return correct decorator class' do
    assert_equal PaginatingDecorator, ApplicationDecorator.collection_decorator_class
  end

  #
  # == Status tag
  #
  test 'should return status_tag for french language' do
    assert_match '<span class="status_tag français blue">Français</span>', @newsletter_user_decorated.lang
  end

  test 'should return status_tag for english language' do
    @newsletter_user.update_attribute(:lang, 'en')
    assert_match '<span class="status_tag english red">English</span>', @newsletter_user_decorated.lang
  end

  private

  def initialize_test
    @setting = settings(:one)
    @contact = categories(:contact)
    @comment = comments(:one)
    @blog_setting = blog_settings(:one)
    @blog_article = blogs(:blog_online)
    @blog_article_2 = blogs(:blog_third)
    @newsletter_user = newsletter_users(:newsletter_user_fr)
    @audio = audios(:one)

    @comment_decorated = ApplicationDecorator.new(@comment)
    @blog_setting_decorated = ApplicationDecorator.new(@blog_setting)
    @blog_article_decorated = ApplicationDecorator.new(@blog_article)
    @blog_article_2_decorated = ApplicationDecorator.new(@blog_article_2)
    @contact_decorated = ApplicationDecorator.new(@contact)
    @newsletter_user_decorated = ApplicationDecorator.new(@newsletter_user)
    @audio_decorated = ApplicationDecorator.new(@audio)
  end
end
