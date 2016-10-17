# frozen_string_literal: true

#
# == Module OptionalModules
#
module OptionalModules
  #
  # == Module Assets
  #
  module Assets
    #
    # == Backgroundable Concerns
    #
    module Backgroundable
      extend ActiveSupport::Concern
      include ApplicationHelper

      included do
        has_one :background, as: :attachable, dependent: :destroy
        accepts_nested_attributes_for :background, reject_if: :all_blank, allow_destroy: true
      end

      #
      # == Background
      #
      def background?
        background.present? # && background.image.exists?
      end
    end
  end
end
