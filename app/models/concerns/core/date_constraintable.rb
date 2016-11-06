# frozen_string_literal: true

#
# == Core namespace
#
module Core
  #
  # == DateConstraintable module
  #
  module DateConstraintable
    extend ActiveSupport::Concern

    included do
      def date_constraints
        k = klass_attrs
        return true unless send(k[:end_attr]) <= send(k[:start_attr])
        errors.add k[:start_attr].to_sym, I18n.t(k[:start_attr], scope: self.class::I18N_SCOPE)
        errors.add k[:end_attr].to_sym, I18n.t(k[:end_attr], scope: self.class::I18N_SCOPE)
      end

      # Return column name depending on model
      def klass_attrs
        klass = self.class.name.underscore
        {
          start_attr: klass == 'event' ? 'start_date' : 'published_at',
          end_attr: klass == 'event' ? 'end_date' : 'expired_at'
        }
      end

      # PublicationDate
      def publication_dates?
        !(published_at.blank? || expired_at.blank?)
      end

      # Event
      def calendar_dates?
        !all_day? ||
          (has_attribute?(end_date) &&
            !start_date.blank? && !end_date.blank?)
      end
    end
  end
end
