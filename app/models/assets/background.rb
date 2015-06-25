# == Schema Information
#
# Table name: backgrounds
#
#  id                 :integer          not null, primary key
#  attachable_id      :integer
#  attachable_type    :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  retina_dimensions  :text(65535)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

#
# == Background Model
#
class Background < ActiveRecord::Base
  include Imageable
  belongs_to :attachable, polymorphic: true

  retina!
  has_attached_file :image,
                    path: ':rails_root/public/system/backgrounds/:id/:style-:filename',
                    url:  '/system/backgrounds/:id/:style-:filename',
                    styles: {
                      background: '4000x2000>',
                      large:      '2000x1200>',
                      medium:     '1000x600>',
                      small:      '300x300>'
                    },
                    retina: { quality: 70 },
                    default_url: '/assets/images/background.jpg'

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  @child_classes = [:Contact]

  def self.child_classes
    Post.subclasses.each do |subclass|
      @child_classes << subclass.name
    end

    @child_classes
  end
end
