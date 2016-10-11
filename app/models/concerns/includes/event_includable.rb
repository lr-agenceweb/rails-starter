# frozen_string_literal: true

#
# == Module Includes
#
module Includes
  #
  # == EventIncludable module
  #
  module EventIncludable
    extend ActiveSupport::Concern

    included do
      def self.includes_collection
        includes(:translations, :picture, :video_upload, :video_uploads, :video_platform, :video_platforms, :location, referencement: [:translations])
      end
    end
  end
end
