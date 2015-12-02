#
# == PrevNextable module
#
module PrevNextable
  extend ActiveSupport::Concern

  # For Event object, start_date is used to determine the previous record
  included do
    def fetch_prev
      return self.class.where('start_date < ? AND id <> ?', start_date, id).online.last if self.class.name == 'Event'
      self.class.where('id < ?', id).online.last
    end

    def fetch_next
      return self.class.where('start_date > ? AND id <> ?', start_date, id).online.first if self.class.name == 'Event'
      self.class.where('id > ?', id).online.first
    end

    def prev?
      !fetch_prev.blank?
    end

    def next?
      !fetch_next.blank?
    end
  end
end
