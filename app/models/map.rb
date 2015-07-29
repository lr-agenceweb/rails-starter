# == Schema Information
#
# Table name: maps
#
#  id              :integer          not null, primary key
#  address         :string(255)
#  city            :string(255)
#  postcode        :integer
#  geocode_address :string(255)
#  latitude        :float(24)
#  longitude       :float(24)
#  marker_icon     :string(255)
#  marker_color    :string(255)
#  show_map        :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

#
# == Map Model
#
class Map < ActiveRecord::Base
  validates :postcode, allow_blank: true, numericality: { only_integer: true }

  def self.allowed_markers
    %w( camera building park car bus college gift )
  end
end
