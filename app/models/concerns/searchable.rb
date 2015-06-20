#
# == Searchable module
#
module Searchable
  extend ActiveSupport::Concern

  included do
    # before_create :generate_token

    def self.search(search, locale)
      if search
        wildcard_search = "%#{search}%"
        with_translations(locale).where("#{self}_translations.title LIKE ? OR #{self}_translations.content LIKE ?", wildcard_search, wildcard_search)
        # .page(page)
        # .per_page(5)
      else
        with_translations(locale)
      end
    end
  end
end
