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
    # == VideoPlatformable Concerns
    #
    module VideoPlatformable
      extend ActiveSupport::Concern

      included do
        has_many :video_platforms, -> { order(:position) }, as: :videoable, dependent: :destroy
        accepts_nested_attributes_for :video_platforms, reject_if: :all_blank, allow_destroy: true

        delegate :online, to: :video_platforms, prefix: true, allow_nil: true

        def video_platforms?
          video_platforms.first.present?
        end
      end
    end
  end
end
