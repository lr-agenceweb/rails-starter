# frozen_string_literal: true

#
# == Module Includes
#
module Includes
  #
  # == BlogIncludable module
  #
  module BlogIncludable
    extend ActiveSupport::Concern

    included do
      def self.includes_collection
        includes(:translations, :user, :picture, :video_upload, :video_uploads, :video_platforms, blog_category: [:translations], referencement: [:translations])
      end
    end
  end
end
