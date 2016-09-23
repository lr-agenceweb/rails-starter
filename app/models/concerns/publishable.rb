# frozen_string_literal: true

#
# == Publishable module
#
module Publishable
  extend ActiveSupport::Concern

  included do
    has_one :publication_date, as: :publishable, dependent: :destroy
    accepts_nested_attributes_for :publication_date, reject_if: :all_blank, allow_destroy: true
  end
end
