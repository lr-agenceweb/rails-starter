# frozen_string_literal: true

#
# == ActiveAdmin namespace
#
module ActiveAdmin
  #
  # == AjaxDestroyable
  #
  module AjaxDestroyable
    extend ActiveSupport::Concern

    included do
      def destroy
        super do |format|
          format.js {}
        end
      end
    end
  end
end
