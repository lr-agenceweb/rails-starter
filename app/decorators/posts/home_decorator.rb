# frozen_string_literal: true

#
# == HomeDecorator
#
class HomeDecorator < PostDecorator
  include Draper::LazyHelpers
  delegate_all
end
