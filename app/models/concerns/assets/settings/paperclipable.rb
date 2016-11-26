# frozen_string_literal: true

#
# == Module Assets
#
module Assets
  #
  # == Module Settings
  #
  module Settings
    #
    # == Paperclipable Concerns
    #
    module Paperclipable
      extend ActiveSupport::Concern

      included do
        include Assets::Attachable

        ATTACHMENT_MAX_SIZE = 2 # megabytes
        ATTACHMENT_TYPES = %r{\Aimage\/.*\Z}

        retina!

        # Paperclip attributes
        handle_attachment :logo,
                          styles: {
                            large: '256x256>',
                            medium: '128x128>',
                            small: '64x64>',
                            thumb: '32x32>'
                          }
        handle_attachment :logo_footer,
                          styles: {
                            large: '256x256>',
                            medium: '128x128>',
                            small: '64x64>',
                            thumb: '32x32>'
                          }

        include Assets::DeletableAttachment
      end
    end
  end
end
