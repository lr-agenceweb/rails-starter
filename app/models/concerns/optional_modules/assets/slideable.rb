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
    # == Slideable Concerns
    #
    module Slideable
      extend ActiveSupport::Concern
      include ApplicationHelper

      included do
        has_many :slides, -> { order(:position) }, as: :attachable, dependent: :destroy
        accepts_nested_attributes_for :slides, reject_if: :all_blank, allow_destroy: true

        has_one :slide, as: :attachable, dependent: :destroy
        accepts_nested_attributes_for :slide, reject_if: :all_blank, allow_destroy: true

        delegate :title, :description, :online, to: :slide, prefix: true, allow_nil: true
        delegate :online, to: :slides, prefix: true, allow_nil: true
      end

      #
      # == Slides
      #
      def slides?
        slides.online.first.present? && slides.online.first.image.exists?
      end

      def slide?
        slide.online && slide.image.exists?
      end
    end
  end
end
