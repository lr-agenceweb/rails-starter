#
# == Validatable module
#
module Validatable
  extend ActiveSupport::Concern

  included do
    after_initialize :set_validated

    def set_validated
      klass = "#{self.class}Setting".constantize
      self.validated = klass.first.should_validate? ? false : true
    end
  end
end
