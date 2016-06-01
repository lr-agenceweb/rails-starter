# frozen_string_literal: true

#
# == Module OptionalModules
#
module OptionalModules
  #
  # == Commentable module
  #
  module Commentable
    extend ActiveSupport::Concern

    included do
      has_many :comments, as: :commentable, dependent: :destroy
      accepts_nested_attributes_for :comments, reject_if: :all_blank, allow_destroy: true
    end
  end
end
