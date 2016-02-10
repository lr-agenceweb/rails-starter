require 'test_helper'

#
# == OptionalModuleDecorator test
#
class OptionalModuleDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  #
  # OptionalModule informations
  #
  test 'should return correct author for post' do
    assert_equal '<strong>Blog</strong>', @blog_optional_module_decorated.name_deco
  end

  #
  # ActiveAdmin
  #
  test 'should return correct AA show page title' do
    assert_equal 'Blog', @blog_optional_module_decorated.title_aa_show
    assert_equal 'Blog', @blog_optional_module_decorated.send(:title_aa_show)
  end

  #
  # == Status tag
  #
  test 'should return correct status_tag for module enabled' do
    assert_match "<span class=\"status_tag activé green\">Activé</span>", @blog_optional_module_decorated.status
  end

  test 'should return correct status_tag for module disabled' do
    @blog_optional_module.update_attribute(:enabled, false)
    assert_match "<span class=\"status_tag désactivé red\">Désactivé</span>", @blog_optional_module_decorated.status
  end

  private

  def initialize_test
    @blog_optional_module = optional_modules(:blog)
    @blog_optional_module_decorated = OptionalModuleDecorator.new(@blog_optional_module)
  end
end
