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
      # FIXME: title_changed? or attribute_changed? seems to be broken
      def should_generate_new_friendly_id?
        model_name = self.class.name.classify.constantize
        new_record? || attribute_changed?(model_name::CANDIDATE) || super
      end
    end

    #
    # ClassMethod
    # =============
    module ClassMethods
      def friendlyze_me
        model_name = table_name.classify.constantize

        translates(*model_name::TRANSLATED_FIELDS,
        fallbacks_for_empty_translations: true)
        active_admin_translates(*model_name::TRANSLATED_FIELDS, fallbacks_for_empty_translations: true) do
          validates model_name::CANDIDATE,
                    presence: true
        end

        extend FriendlyId
        friendly_id :slug_candidates,
                    use: [:slugged,
                          :globalize,
                          # :history,
                          :finders]
      end
    end # ClassMethod

    private

    def slug_candidates
      model_name = self.class.name.classify.constantize
      [
        model_name::CANDIDATE,
        [model_name::CANDIDATE, resource_id]
      ]
    end

    def resource_id
      model_name = self.class.name.classify.constantize
      id = model_name.where("#{model_name::CANDIDATE}": send(model_name::CANDIDATE)).count
      return id unless id.zero?
    end
  end # FriendlyGlobalizeSluggable
end # Core
