# frozen_string_literal: true
require 'test_helper'

#
# BlogDecorator test
# ====================
class BlogDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # ActiveAdmin
  # =============
  test 'should return correct AA show page title' do
    expected = I18n.t('post.title_aa_show', page: I18n.t('activerecord.models.blog.one'), title: @blog_decorated.title)
    assert_equal expected, @blog_decorated.title_aa_show
  end

  test 'should return correct html for create_blog_category_link' do
    expected = 'Si votre catégorie n\'apparait pas dans la liste, vous pouvez <a class="button" href="/admin/blog_categories/new">l\'ajouter</a>'
    assert_equal expected, @blog_decorated.create_blog_category_link
  end

  private

  def initialize_test
    @blog = blogs(:blog_online)
    @blog_decorated = BlogDecorator.new(@blog)
  end
end
