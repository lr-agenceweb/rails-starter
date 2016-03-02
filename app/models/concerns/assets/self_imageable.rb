#
# == Module Assets
#
module Assets
  #
  # == SelfImageable Concerns
  #
  module SelfImageable
    extend ActiveSupport::Concern
    include ApplicationHelper

    included do
      # check if own model has image
      def self_image?
        image.exists?
      end

      # Return paperclip object url for own model
      def self_image_url_by_size(size)
        image.url(size)
      end
    end
  end
end
