# frozen_string_literal: true

#
# == Core namespace
#
module Core
  #
  # == Headingable module
  #
  module Headingable
    extend ActiveSupport::Concern

    included do
      has_one :heading, as: :headingable, dependent: :destroy
      accepts_nested_attributes_for :heading, reject_if: :all_blank, allow_destroy: false

      delegate :content, to: :heading, prefix: true, allow_nil: true
    end
  end
end
