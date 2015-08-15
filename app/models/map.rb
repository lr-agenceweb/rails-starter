# == Schema Information
#
# Table name: maps
#
#  id           :integer          not null, primary key
#  marker_icon  :string(255)
#  marker_color :string(255)
#  show_map     :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

#
# == Map Model
#
class Map < ActiveRecord::Base
  def self.allowed_markers
    %w( camera building park car bus college gift )
  end

  has_one :location, as: :locationable, dependent: :destroy
  accepts_nested_attributes_for :location, reject_if: :all_blank, allow_destroy: true

  validates :marker_icon,
            presence: false,
            allow_blank: true,
            inclusion: { in: allowed_markers }
end
