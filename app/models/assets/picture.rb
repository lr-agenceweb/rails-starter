# frozen_string_literal: true

#
# Picture Model
# ===============
class Picture < ApplicationRecord
  include Assets::Attachable
  include Assets::SelfImageable

  # Translations
  translates :title, :description, fallbacks_for_empty_translations: true
  active_admin_translates :title, :description

  # Constants
  ATTACHMENT_MAX_SIZE = 3 # megabytes
  ATTACHMENT_TYPES = [
    'image/jpeg', 'image/png', 'image/gif'
  ].freeze

  # Model relations
  belongs_to :attachable, polymorphic: true, touch: true

  retina!
  handle_attachment :image,
                    styles: {
                      huge:   '1024x1024>',
                      large:  '512x512>',
                      medium: '256x256>',
                      small:  '90x90>',
                      thumb:  '30x30>'
                    }

  # Scopes
  scope :online, -> { where(online: true) }
end

# == Schema Information
#
# Table name: pictures
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
#  index_pictures_on_attachable_type_and_attachable_id  (attachable_type,attachable_id)
#
