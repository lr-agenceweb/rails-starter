# frozen_string_literal: true

#
# Core namespace
# =================
module Core
  #
  # FriendlyGlobalizeSluggable module
  # ====================================
  module FriendlyGlobalizeSluggable
    extend ActiveSupport::Concern

    included do
      ATTRIBUTE ||= :title
      TRANSLATED_FIELDS ||= [:title, :slug, :content].freeze

      translates(*TRANSLATED_FIELDS,
                 fallbacks_for_empty_translations: true)
      active_admin_translates(*TRANSLATED_FIELDS, fallbacks_for_empty_translations: true) do
        validates ATTRIBUTE,
                  presence: true
      end

      extend FriendlyId
      friendly_id :slug_candidates,
                  use: [:slugged,
                        :globalize,
                        # :history,
                        :finders]

      private

      def slug_candidates
        [
          ATTRIBUTE,
          [ATTRIBUTE, resource_id]
        ]
      end

      def resource_id
        id = self.class.where("#{ATTRIBUTE}": send(ATTRIBUTE)).count
        return id unless id.zero?
      end

      # FIXME: title_changed? or attribute_changed? seems to be broken
      def should_generate_new_friendly_id?
        new_record? || attribute_changed?(ATTRIBUTE) || super
      end
    end
  end
end
