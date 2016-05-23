# frozen_string_literal: true

#
# == ConnectionDecorator
#
class ConnectionDecorator < PostDecorator
  include Draper::LazyHelpers
  delegate_all
end
