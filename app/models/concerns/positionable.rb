#
# == Positionable module
#
module Positionable
  extend ActiveSupport::Concern

  included do
    acts_as_list
    scope :by_position, -> { order(position: :asc) }
  end
end
