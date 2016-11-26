# frozen_string_literal: true

#
# == Validatable module
#
module Validatable
  extend ActiveSupport::Concern

  included do
    include UserHelper
    after_initialize :set_validated, if: proc { |u| u.new_record? }

    def set_validated
      klass = "#{self.class}Setting".constantize
      self.validated = true
      self.validated = false if klass.first.try(:should_validate?) && !current_user_and_administrator?(User.try(:current_user))
    end
  end
end
