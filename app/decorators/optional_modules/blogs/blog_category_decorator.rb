# frozen_string_literal: true

#
# == BlogCategoryDecorator
#
class BlogCategoryDecorator < PostDecorator
  include Draper::LazyHelpers
  delegate_all
end
