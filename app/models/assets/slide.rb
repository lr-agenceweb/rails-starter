# frozen_string_literal: true
# == Schema Information
#
# Table name: slides
#
#  id                 :integer          not null, primary key
#  attachable_id      :integer
#  attachable_type    :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  title              :string(255)
#  description        :text(65535)
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

#
# == Slide Model
#
class Slide < ActiveRecord::Base
  include Assets::Attachable
  include Assets::SelfImageable

  translates :title, :description, fallbacks_for_empty_translations: true
  active_admin_translates :title, :description

  belongs_to :attachable, polymorphic: true, touch: true

  retina!
  handle_attachment :image,
                    styles: {
                      slide: '1920x650#',
                      medium: '960x450#',
                      small: '480x250#',
                      crop_thumb: '100x100#'
                    }

  validates_attachment_content_type :image, content_type: %r{\Aimage\/.*\Z}

  scope :online, -> { where(online: true) }
end
