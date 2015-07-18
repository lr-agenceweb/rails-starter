# == Schema Information
#
# Table name: pictures
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
#  online             :boolean          default(TRUE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_pictures_on_attachable_id    (attachable_id)
#  index_pictures_on_attachable_type  (attachable_type)
#

#
# == Picture Model
#
class Picture < ActiveRecord::Base
  translates :title, :description, fallbacks_for_empty_translations: true
  active_admin_translates :title, :description

  belongs_to :attachable, polymorphic: true

  retina!
  has_attached_file :image,
                    storage: :dropbox,
                    dropbox_credentials: Rails.root.join('config/dropbox.yml'),
                    path: '/pictures/:id/:style-:filename',
                    url:  '/pictures/:id/:style-:filename',
                    styles: {
                      huge:   '1024x1024>',
                      large:  '512x512>',
                      medium: '256x256>',
                      small:  '90x90>>',
                      thumb:  '30x30>'
                    },
                    retina: { quality: 70 },
                    default_url: '/default/:style-missing.png'

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  scope :online,  -> { where(online: true) }
end
