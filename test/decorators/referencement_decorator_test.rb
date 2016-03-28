# frozen_string_literal: true
require 'test_helper'

#
# == ReferencementDecorator test
#
class ReferencementDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers

  setup :initialize_test

  test 'should return correct left caracters with description' do
    referencement_about = ReferencementDecorator.new(@referencement_about)
    assert_equal 117, referencement_about.letters_length
  end

  test 'should return correct left caracters without description' do
    referencement_home = ReferencementDecorator.new(@referencement_home)
    assert_equal 150, referencement_home.letters_length
  end

  private

  def initialize_test
    @referencement_about = referencements(:two)
    @referencement_home = referencements(:one)
  end
end
