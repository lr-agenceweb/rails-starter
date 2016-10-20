# frozen_string_literal: true
require 'test_helper'

#
# == ReferencementDecorator test
#
class ReferencementDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers
  delegate_all
end
