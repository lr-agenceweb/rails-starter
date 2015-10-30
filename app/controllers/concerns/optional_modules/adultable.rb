#
# == AdultableConcern
#
module Adultable
  extend ActiveSupport::Concern

  included do
    before_action :set_adult_validation, if: proc { @adult_module.enabled? && !cookies[:adult] }

    def set_adult_validation
      adult_string_box = StringBox.find_by(key: 'adult_not_validated_popup_content')
      gon.push(
        adult_validation: true,
        adult_not_validated_popup_title: adult_string_box.title,
        adult_not_validated_popup_content: adult_string_box.content
      )
    end
  end
end
