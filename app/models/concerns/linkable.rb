# frozen_string_literal: true
#
# == Linkable module
#
module Linkable
  extend ActiveSupport::Concern

  included do
    has_one :link, as: :linkable, dependent: :destroy
    accepts_nested_attributes_for :link, reject_if: :all_blank, allow_destroy: true
  end
end
