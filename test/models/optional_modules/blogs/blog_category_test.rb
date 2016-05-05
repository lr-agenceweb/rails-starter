# frozen_string_literal: true
require 'test_helper'

#
# == BlogCategory test
#
class BlogCategoryTest < ActiveSupport::TestCase
  #
  # == Validation rules
  #
  test 'should not be valid if name is not set' do
    blog_category = BlogCategory.new
    refute blog_category.valid?, 'should not be valid if name is not set'
    assert_equal [:name], blog_category.errors.keys
  end

  test 'should not be valid if name is empty' do
    attrs = { name: '' }
    blog_category = BlogCategory.new attrs
    refute blog_category.valid?, 'should not be valid if name is empty'
    assert_equal [:name], blog_category.errors.keys
  end

  test 'should not be valid if name is already taken' do
    attrs = { name: 'foo' }
    blog_category = BlogCategory.new attrs
    refute blog_category.valid?, 'should not be valid if name is already taken'
    assert_equal [:name], blog_category.errors.keys
  end

  test 'should be valid if name is set properly' do
    attrs = { name: 'foobar' }
    blog_category = BlogCategory.new attrs
    assert blog_category.valid?, 'should be valid if name is set properly'
    assert_empty blog_category.errors.keys
  end
end
