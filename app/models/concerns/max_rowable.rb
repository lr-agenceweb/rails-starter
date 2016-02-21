#
# == MaxRowable module
#
module MaxRowable
  extend ActiveSupport::Concern

  included do
    validate :validate_max_row_allowed

    private

    def validate_max_row_allowed
      errors.add :max_row, I18n.t('form.errors.max_row') if self.class.count >= 1 && new_record?
    end
  end
end
