#
# == Scopable module
#
module Scopable
  extend ActiveSupport::Concern

  included do
    scope :by_locale, -> (locale) { where(lang: locale) }
    scope :francais, -> { where(lang: 'fr') }
    scope :english, -> { where(lang: 'en') }
    scope :validated, -> { where(validated: true) }
    scope :to_validate, -> { where(validated: false) }
  end
end
