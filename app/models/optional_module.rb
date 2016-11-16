# frozen_string_literal: true

#
# == OptionalModule Model
#
class OptionalModule < ApplicationRecord
  has_one :page, dependent: :destroy
  has_many :string_boxes, dependent: :destroy

  def self.list
    %w(Newsletter GuestBook Search RSS Comment Blog Adult Slider Event Map Social Breadcrumb Qrcode Background Calendar Video Mailing SocialConnect Audio Analytics)
  end

  def self.by_name(name)
    find_by(name: name)
  end
end

# == Schema Information
#
# Table name: optional_modules
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text(65535)
#  enabled     :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
