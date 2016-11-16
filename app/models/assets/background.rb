# frozen_string_literal: true

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
# Indexes
#
#  index_backgrounds_on_attachable_type_and_attachable_id  (attachable_type,attachable_id)
#

#
# == Background Model
#
class Background < ApplicationRecord
  include Assets::Attachable
  include Assets::SelfImageable

  ATTACHMENT_MAX_SIZE = 5 # megabytes
  ATTACHMENT_TYPES = %r{\Aimage\/.*\Z}

  belongs_to :attachable, polymorphic: true, touch: true

  retina!
  handle_attachment :image,
                    styles: {
                      background: '2000x1000>',
                      large:      '1000x600>',
                      medium:     '500x300>',
                      small:      '150x150>'
                    }

  validates_attachment :image,
                       content_type: { content_type: ATTACHMENT_TYPES },
                       size: { less_than: ATTACHMENT_MAX_SIZE.megabyte }

  validates :attachable_type,
            presence: true,
            allow_blank: false,
            inclusion: %w(Page)

  @child_classes = [:Contact]

  def self.child_classes
    Post.subclasses.each do |subclass|
      @child_classes << subclass.name.to_sym
    end

    @child_classes
  end
end
