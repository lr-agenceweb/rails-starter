# frozen_string_literal: true

#
# Background Model
# ==================
class Background < ApplicationRecord
  include Assets::Attachable
  include Assets::SelfImageable

  # Constants
  ATTACHMENT_MAX_SIZE = 5 # megabytes
  ATTACHMENT_TYPES = %r{\Aimage\/.*\Z}

  # Model relations
  belongs_to :attachable, polymorphic: true, touch: true

  retina!
  handle_attachment :image,
                    styles: {
                      background: '2000x1000>',
                      large:      '1000x600>',
                      medium:     '500x300>',
                      small:      '150x150>'
                    }

  # Validation rules
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

# == Schema Information
#
# Table name: backgrounds
#
#  id                 :integer          not null, primary key
#  attachable_type    :string(255)
#  attachable_id      :integer
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
