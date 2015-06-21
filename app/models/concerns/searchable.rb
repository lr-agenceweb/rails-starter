#
# == Searchable module
#
module Searchable
  extend ActiveSupport::Concern

  included do
    def self.search(search, locale)
      if search
        wildcard_search = "%#{search}%"
        with_translations(locale).online.where("#{self.to_s.downcase}_translations.title LIKE ? OR #{self.to_s.downcase}_translations.content LIKE ?", wildcard_search, wildcard_search)
      end
    end
  end
end
