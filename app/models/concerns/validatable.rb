# frozen_string_literal: true
#
# == Validatable module
#
module Validatable
  extend ActiveSupport::Concern

  included do
    after_initialize :set_validated, if: proc { |o| o.new_record? }

    def set_validated
      klass = "#{self.class}Setting".constantize
      self.validated = klass.first.try(:should_validate?) ? false : true
    end
  end
end
