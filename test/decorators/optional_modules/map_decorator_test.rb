require 'test_helper'

#
# == MapDecorator test
#
class MapDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  test 'should have correct AA title for show page' do
    map_decorated = MapDecorator.new(@map)
    assert_equal 'Carte', map_decorated.title_aa_show
  end

  test 'should return correct full address' do
    map_decorated = MapDecorator.new(@map)
    assert_equal '<span>1 Main Street, 06001 - Auckland</span>', map_decorated.full_address_inline
  end

  #
  # == Status tag
  #
  test 'should return correct status_tag for show_map' do
    map_decorated = MapDecorator.new(@map)
    assert_match "<span class=\"status_tag affichée green\">Affichée</span>", map_decorated.status
  end

  private

  def initialize_test
    @map = maps(:one)
  end
end
