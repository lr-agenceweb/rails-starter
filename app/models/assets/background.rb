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
  include Attachable

  belongs_to :attachable, polymorphic: true

  retina!
  handle_attachment :image,
                    styles: {
                      background: '4000x2000>',
                      large:      '2000x1200>',
                      medium:     '1000x600>',
                      small:      '300x300>'
                    }

  validates_attachment_content_type :image, content_type: %r{\Aimage\/.*\Z}

  @child_classes = [:Contact]

  def self.child_classes
    Post.subclasses.each do |subclass|
      @child_classes << subclass.name
    end

    @child_classes
  end
end
