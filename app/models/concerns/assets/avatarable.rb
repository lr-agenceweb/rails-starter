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

      retina!
      handle_attachment :avatar,
                        styles: {
                          large:  '512x512#',
                          medium: '256x256#',
                          small:  '128x128#',
                          thumb:  '64x64#'
                        }

      validates_attachment :avatar,
                           content_type: { content_type: %r{\Aimage\/.*\Z} },
                           size: { less_than: 2.megabyte }

      include Assets::DeletableAttachment

      def avatar?
        avatar.present? && avatar.exists?
      end
    end
  end
end
