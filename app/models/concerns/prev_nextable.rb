# frozen_string_literal: true

#
# PrevNextable module
# =====================
module PrevNextable
  extend ActiveSupport::Concern

  # For Event object, start_date is used to determine the previous record
  included do
    include Core::PageHelper
    include Rails.application.routes.url_helpers

    # Delegates
    delegate :title, to: :fetch_prev, prefix: true
    delegate :title, to: :fetch_next, prefix: true

    #
    # Prev / Next
    # =============
    def prev_post
      resource_route_show(fetch_prev)
    end

    def next_post
      resource_route_show(fetch_next)
    end

    def fetch_prev
      return self.class.where('start_date <= ? AND id <> ?', start_date, id).order('start_date DESC').online.first if self.class.name == 'Event'
      self.class.where('id < ?', id).online.last
    end

    def fetch_next
      return self.class.where('start_date >= ? AND id <> ?', start_date, id).order('start_date ASC').online.first if self.class.name == 'Event'
      self.class.where('id > ?', id).online.first
    end

    #
    # Boolean
    # =========
    def prev?
      !fetch_prev.blank?
    end

    def next?
      !fetch_next.blank?
    end
  end
end
