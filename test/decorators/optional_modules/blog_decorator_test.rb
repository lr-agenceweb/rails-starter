require 'test_helper'

#
# == BlogDecorator test
#
class BlogDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  test 'should return correct AA show page title' do
    blog_decorated = BlogDecorator.new(@blog)
    assert_equal "Article lié à la page \"Blog articles\"", blog_decorated.title_aa_show
  end

  private

  def initialize_test
    @blog = blogs(:blog_online)
  end
end
