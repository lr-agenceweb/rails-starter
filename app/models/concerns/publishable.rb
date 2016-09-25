# frozen_string_literal: true

#
# == Publishable module
#
module Publishable
  extend ActiveSupport::Concern

  included do
    # Model relations
    has_one :publication_date, as: :publishable, dependent: :destroy
    accepts_nested_attributes_for :publication_date, allow_destroy: false

    # Delegates
    delegate :published_later, :published_at,
             :expired_prematurely, :expired_at,
             :published_later?, :expired_prematurely?,
             to: :publication_date, prefix: false, allow_nil: true

    # Scopes
    scope :published, -> { joins(:publication_date).online.where('(publication_dates.published_at IS NULL AND publication_dates.expired_at IS NULL) OR (publication_dates.published_at <= ? AND publication_dates.expired_at > ?) OR (publication_dates.published_at <= ? AND publication_dates.expired_at IS NULL) OR (publication_dates.published_at IS NULL AND publication_dates.expired_at > ?)', Time.zone.today, Time.zone.today, Time.zone.today, Time.zone.today) }

    # TODO: Cleanup this code
    def published?
      today = Time.zone.today

      # Published_at and Expired_at blank
      return true if published_at.blank? && expired_at.blank?

      # Published_at and Expired_at present
      return today.between?(published_at, expired_at) if published_at.present? && expired_at.present?

      # Published_at only
      return published_at <= today if published_at.present?

      # Expired_at only
      return expired_at >= today if expired_at.present?
    end
  end
end
