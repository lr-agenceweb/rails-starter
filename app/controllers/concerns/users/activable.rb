# frozen_string_literal: true

#
# == Users namespace
#
module Users
  #
  # == ActivableConcern
  #
  module Activable
    extend ActiveSupport::Concern

    included do
      before_action :configure_permitted_parameters, if: :devise_controller?

      private

      def configure_permitted_parameters
        devise_parameter_sanitizer.for(:sign_up) << :provider
      end
    end
  end
end
