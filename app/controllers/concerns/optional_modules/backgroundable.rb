# frozen_string_literal: true

#
# == OptionalModules namespace
#
module OptionalModules
  #
  # == BackgroundableConcern
  #
  module Backgroundable
    extend ActiveSupport::Concern

    included do
      before_action :set_background, if: proc { @background_module.enabled && !@page.nil? }
      decorates_assigned :background

      def set_background
        @background = @page.background
      end
    end
  end
end
