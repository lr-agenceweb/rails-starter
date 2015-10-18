#
# == PrevNextable module
#
module PrevNextable
  extend ActiveSupport::Concern

  included do
    def fetch_prev
      self.class.where('id < ?', id).last
    end

    def fetch_next
      self.class.where('id > ?', id).first
    end

    def prev?
      !fetch_prev.blank?
    end

    def next?
      !fetch_next.blank?
    end
  end
end
