# frozen_string_literal: true

#
# == OptionalModules namespace
#
module OptionalModules
  #
  # == OptionalModulableConcern
  #
  module OptionalModulable
    extend ActiveSupport::Concern

    included do
      before_action :set_optional_modules

      def set_optional_modules
        @optional_mod = OptionalModule.all
        @optional_mod.find_each do |optional_module|
          instance_variable_set("@#{optional_module.name.underscore.singularize}_module", optional_module)
        end
      end
    end
  end
end
