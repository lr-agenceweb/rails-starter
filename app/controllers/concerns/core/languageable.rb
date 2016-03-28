# frozen_string_literal: true
#
# == Core namespace
#
module Core
  #
  # == LanguageableConcern
  #
  module Languageable
    extend ActiveSupport::Concern

    included do
      before_action :set_language

      def set_language
        @language = I18n.locale
        gon.push(language: @language)
      end
    end
  end
end
