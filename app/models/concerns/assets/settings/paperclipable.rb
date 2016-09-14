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

        # Paperclip validation rules
        validates_attachment :logo,
                             content_type: { content_type: %r{\Aimage\/.*\Z} },
                             size: { less_than: 2.megabyte }
        validates_attachment :logo_footer,
                             content_type: { content_type: %r{\Aimage\/.*\Z} },
                             size: { less_than: 2.megabyte }

        include Assets::DeletableAttachment
      end
    end
  end
end
