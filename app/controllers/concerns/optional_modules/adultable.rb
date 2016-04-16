# frozen_string_literal: true
#
# == OptionalModules namespace
#
module OptionalModules
  #
  # == AdultableConcern
  #
  module Adultable
    extend ActiveSupport::Concern

    included do
      before_action :set_adult_validation, if: proc { @adult_module.enabled? && AdultSetting.first.enabled? && !cookies[:adult] }

      def set_adult_validation
        adult_string_box = AdultSetting.decorate.first
        gon.push(
          adult_validation: true,
          adult_not_validated_popup_title: adult_string_box.title,
          adult_not_validated_popup_content: adult_string_box.content,
          adult_not_validated_popup_redirect_link: adult_string_box.redirect_link
        )
      end
    end
  end
end
