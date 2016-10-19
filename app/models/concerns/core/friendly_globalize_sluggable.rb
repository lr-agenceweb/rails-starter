# frozen_string_literal: true

#
# == Core namespace
#
module Core
  #
  # == FriendlyGlobalizeSluggable module
  #
  module FriendlyGlobalizeSluggable
    extend ActiveSupport::Concern

    included do
      TRANSLATED_FIELDS ||= [:title, :slug, :content].freeze
      translates(*TRANSLATED_FIELDS,
                 fallbacks_for_empty_translations: true)
      active_admin_translates(*TRANSLATED_FIELDS, fallbacks_for_empty_translations: true) do
        validates :title,
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
        [[:title, :deduced_id]]
      end

      def deduced_id
        record_id = self.class.where(title: title).count
        return record_id + 1 unless record_id == 0
      end

      def should_generate_new_friendly_id?
        new_record? || title_changed? || super
      end
    end
  end
end
