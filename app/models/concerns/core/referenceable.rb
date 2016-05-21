# frozen_string_literal: true

#
# == Core namespace
#
module Core
  #
  # == Referenceable module
  #
  module Referenceable
    extend ActiveSupport::Concern

    included do
      has_one :referencement, as: :attachable, dependent: :destroy
      accepts_nested_attributes_for :referencement, reject_if: :all_blank, allow_destroy: true

      delegate :description, :keywords, to: :referencement, prefix: true, allow_nil: true
    end
  end
end
