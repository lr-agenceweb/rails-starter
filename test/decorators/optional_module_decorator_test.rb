# frozen_string_literal: true
require 'test_helper'

#
# == OptionalModuleDecorator test
#
class OptionalModuleDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # == OptionalModule informations
  #
  test 'should return correct author for post' do
    assert_equal '<strong>Blog</strong>', @blog_optional_module_decorated.name
  end

  #
  # == ActiveAdmin
  #
  test 'should return correct AA show page title' do
    assert_equal 'Blog', @blog_optional_module_decorated.title_aa_show
    assert_equal 'Blog', @blog_optional_module_decorated.send(:title_aa_show)
  end

  private

  def initialize_test
    @blog_optional_module = optional_modules(:blog)
    @blog_optional_module_decorated = OptionalModuleDecorator.new(@blog_optional_module)
  end
end
