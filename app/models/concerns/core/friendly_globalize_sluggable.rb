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
                        :history,
                        :globalize,
                        :finders]

      private

      def slug_candidates
        [[ATTRIBUTE, :deduced_id]]
      end

      def deduced_id
        record_id = self.class.where("#{ATTRIBUTE}": send(ATTRIBUTE)).count
        return record_id + 1 unless record_id.zero?
      end

      # FIXME: title_changed? or attribute_changed? seems to be broken
      def should_generate_new_friendly_id?
        # new_record? || attribute_changed?(ATTRIBUTE) || super
        new_record? || super
      end
    end
  end
end
