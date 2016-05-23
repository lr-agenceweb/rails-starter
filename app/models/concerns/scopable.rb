# frozen_string_literal: true

#
# == Scopable module
#
module Scopable
  extend ActiveSupport::Concern

  included do
    scope :by_locale, -> (locale) { where(lang: locale) }

    scope :french, -> { where(lang: 'fr') }
    scope :english, -> { where(lang: 'en') }

    scope :validated, -> { where(validated: true) }
    scope :to_validate, -> { where(validated: false) }
  end
end
