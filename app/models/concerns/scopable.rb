#
# == Scopable module
#
module Scopable
  extend ActiveSupport::Concern

  included do
    scope :by_locale, -> (locale) { where(lang: locale) }
    scope :francais, -> { where(lang: 'fr') }
    scope :english, -> { where(lang: 'en') }
  end
end
