#
# == Validatable module
#
module Validatable
  extend ActiveSupport::Concern

  included do
    after_initialize :set_validated

    def set_validated
      self.validated = CommentSetting.first.should_validate? ? false : true
    end
  end
end
