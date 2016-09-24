# frozen_string_literal: true
require 'test_helper'

#
# == BlogDecorator test
#
class BlogDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # == URL
  #
  test 'should return show_page_link' do
    assert_equal blog_category_blog_path(@blog.blog_category, @blog), @blog_decorated.show_page_link
  end

  #
  # == ActiveAdmin
  #
  test 'should return correct AA show page title' do
    expected = I18n.t('post.title_aa_show', page: I18n.t('activerecord.models.blog.one'), title: @blog_decorated.title)
    assert_equal expected, @blog_decorated.title_aa_show
  end

  private

  def initialize_test
    @blog = blogs(:blog_online)
    @blog_decorated = BlogDecorator.new(@blog)
  end
end
