# frozen_string_literal: true

#
# == Module Assets
#
module Assets
  #
  # == Avatarable Concerns
  #
  module Avatarable
    extend ActiveSupport::Concern
    include ApplicationHelper

    included do
      include Assets::Attachable

      ATTACHMENT_MAX_SIZE = 2 # megabytes
      ATTACHMENT_TYPES = %r{\Aimage\/.*\Z}

      retina!
      handle_attachment :avatar,
                        styles: {
                          large:  '256x256#',
                          medium: '128x128#',
                          small:  '64x64#',
                          thumb:  '32x32#'
                        }

      include Assets::DeletableAttachment

      def avatar?
        avatar.present? && avatar.exists?
      end
    end
  end
end
