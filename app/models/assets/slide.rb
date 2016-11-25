# frozen_string_literal: true

#
# Slide Model
# =============
class Slide < ApplicationRecord
  include Assets::Attachable
  include Assets::SelfImageable

  # Constants
  ATTACHMENT_MAX_SIZE = 4 # megabytes
  ATTACHMENT_TYPES = %r{\Aimage\/.*\Z}

  # Translations
  translates :title, :description, fallbacks_for_empty_translations: true
  active_admin_translates :title, :description

  # Model relations
  belongs_to :attachable, polymorphic: true, touch: true

  retina!
  handle_attachment :image,
                    styles: {
                      slide: '1920x650#',
                      medium: '960x450#',
                      small: '480x250#',
                      crop_thumb: '100x100#'
                    }

  # Scopes
  scope :online, -> { where(online: true) }
end

# == Schema Information
#
# Table name: slides
#
#  id                 :integer          not null, primary key
#  attachable_type    :string(255)
#  attachable_id      :integer
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  retina_dimensions  :text(65535)
#  primary            :boolean          default(FALSE)
#  position           :integer
#  online             :boolean          default(TRUE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_slides_on_attachable_type_and_attachable_id  (attachable_type,attachable_id)
#
