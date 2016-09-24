# frozen_string_literal: true

#
# == Publishable module
#
module Publishable
  extend ActiveSupport::Concern

  included do
    # Model relations
    has_one :publication_date, as: :publishable, dependent: :destroy
    accepts_nested_attributes_for :publication_date, reject_if: :all_blank, allow_destroy: true

    # Delegates
    delegate :published_later, :published_at,
             :expired_prematurely, :expired_at,
             :published_later?, :expired_prematurely?,
             to: :publication_date, prefix: false, allow_nil: true
  end
end
