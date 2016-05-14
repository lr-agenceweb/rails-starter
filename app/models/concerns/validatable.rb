# frozen_string_literal: true

#
# == Validatable module
#
module Validatable
  extend ActiveSupport::Concern

  included do
    include UserHelper
    after_initialize :set_validated, if: proc { |o| o.new_record? }

    def set_validated
      klass = "#{self.class}Setting".constantize
      self.validated = (klass.first.try(:should_validate?) && !current_user_and_administrator?(User.try(:current_user))) ? false : true
    end
  end
end
